package db

import (
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"niko_server/model"
	"niko_server/util"
	"sync"
	"time"

	"github.com/rs/zerolog/log"

	cryptoRand "crypto/rand"
)

var nOnce []byte
var gCm cipher.AEAD

func init() {
	//https://tutorialedge.net/golang/go-encrypt-decrypt-aes-tutorial/
	key := []byte("nobody, is breaking my heart but")

	c, err := aes.NewCipher(key)
	// if there are any errors, handle them
	if err != nil {
		log.Fatal().Msg(err.Error())
	}

	// gcm or Galois/Counter Mode, is a mode of operation
	// for symmetric key cryptographic block ciphers
	// - https://en.wikipedia.org/wiki/Galois/Counter_Mode
	gCm, err = cipher.NewGCM(c)
	// if any error generating new GCM
	// handle them
	if err != nil {
		log.Fatal().Msg(err.Error())
	}

	// creates a new byte array the size of the nonce
	// which must be passed to Seal
	nOnce = make([]byte, gCm.NonceSize())
	// populates our nonce with a cryptographically secure
	// random sequence
	if _, err = io.ReadFull(cryptoRand.Reader, nOnce); err != nil {
		fmt.Println(err)
	}

	// here we encrypt our text using the Seal function
	// Seal encrypts and authenticates plaintext, authenticates the
	// additional data and appends the result to dst, returning the updated
	// slice. The nonce must be NonceSize() bytes long and unique for all
	// time, for a given key.
	//fmt.Println(gcm.Seal(nonce, nonce, text, nil))

}

var UserPool = sync.Pool{
	New: func() interface{} {
		return new(User)
	},
}

func GetUser() *User {
	u := UserPool.Get().(*User)
	u.Reset()
	return u
}

func (u *User) Release() {
	UserPool.Put(u)
}

type User struct {
	Id        string
	PassWord  string
	NickName  string
	EMail     string
	CreatedAt string

	SEQ uint32

	*Db

	model.AccountCreateRequest
	model.AccountCreateResponse

	model.AccountLoginRequest
	model.AccountLoginResponse
}

func (u *User) CreateSetting(d *Db) {
	u.Id = u.AccountCreateRequest.Id
	u.PassWord = u.AccountCreateRequest.Password
	u.NickName = u.AccountCreateRequest.NickName
	u.EMail = u.AccountCreateRequest.EMail
	u.CreatedAt = time.Now().Format("2006-01-02 15:04:05-0700")
	u.Db = d
}

func (u *User) LoginSetting(d *Db) {
	u.Id = u.AccountLoginRequest.Id
	u.PassWord = u.AccountLoginRequest.Password
	u.Db = d
}

func (u *User) Reset() {
	u.Id = ""
	u.PassWord = ""
	u.CreatedAt = ""
	u.NickName = ""
	u.EMail = ""

	u.AccountCreateRequest.Reset()
	u.AccountCreateResponse.Reset()

	u.AccountLoginRequest.Reset()
	u.AccountLoginResponse.Reset()
}

// 리턴시 sql.ErrNoRows 체크하여 값 처리
func (u *User) QueryUserId() error {
	db, err := u.GetDB()
	if err != nil {
		return err
	}
	defer u.Close()

	err = db.QueryRow("select id from user where id = ?", u.Id).Scan(&u.Id)
	if err != nil {
		return err
	}

	return nil
}

func (u *User) CheckUserIdAndPassWord() error {
	db, err := u.GetDB()
	if err != nil {
		return err
	}
	defer u.Close()

	err = db.QueryRow("select id, nick_name, e_mail from user where id = ? and pass_word = ?", u.Id, u.PassWord).Scan(&u.Id, &u.NickName, &u.EMail)
	if err != nil {
		return err
	}

	return nil
}

func (u *User) InsertUser() error {

	db, err := u.GetDB()

	if err != nil {
		return err
	}
	defer u.Close()

	tx, err := db.Begin()

	if err != nil {
		return err
	}

	stmt, err := tx.Prepare("insert into user (id,pass_word,nick_name,e_mail,created_at) values (?,?,?,?,?)")

	if err != nil {
		return err
	}

	_, err = stmt.Exec(u.Id, u.PassWord, u.NickName, u.EMail, u.CreatedAt)
	if err != nil {
		return err
	}

	tx.Commit()

	return nil
}

func (u *User) MakeSEQ() {
	u.SEQ = uint32(rand.Float64() * 4294967294)
}

func (u *User) MakeAuthString() string {

	buf := util.GetBuffer()
	defer util.PutBuffer(buf)

	binary.Write(buf, binary.LittleEndian, u.SEQ)
	buf.WriteString(u.Id)

	aesBytes := gCm.Seal(nOnce, nOnce, buf.Bytes(), nil)

	buf2 := util.GetBuffer()
	defer util.PutBuffer(buf2)

	length := uint32(len(aesBytes))
	binary.Write(buf2, binary.LittleEndian, length)
	buf2.Write(aesBytes)

	return base64.StdEncoding.EncodeToString(buf2.Bytes())
}

func (u *User) ParseAuthString(base64String string) error {

	lengthNaes, err := base64.StdEncoding.DecodeString(base64String)
	if err != nil {
		return err
	}

	length := binary.LittleEndian.Uint32(lengthNaes)

	nonceSize := gCm.NonceSize()
	if int(length) < nonceSize {
		return errors.New("size of aesBytes is too short")
	}

	nonce, ciphertext := lengthNaes[4:4+nonceSize], lengthNaes[4+nonceSize:4+length]
	seqNid, err := gCm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return err
	}

	u.SEQ = binary.LittleEndian.Uint32(seqNid)
	u.Id = string(seqNid[4:])

	return nil
}
