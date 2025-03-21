package api

import (
	"database/sql"
	"niko_server/db"
	"niko_server/model"

	"github.com/gofiber/fiber/v2"
)

func init() {
	isFunctionHashCreated()
	PostFunctions["/api/account/create"] = new(AccountCreate)
	PostFunctions["/api/account/login"] = new(AccountLogin)

}

type AccountCreate struct {
	Handler
}

func (a *AccountCreate) PostFunction(c *fiber.Ctx) error {

	user := db.GetSession()
	defer user.Release()

	request := &user.AccountCreateRequest
	response := &user.AccountCreateResponse

	if err := c.BodyParser(request); err != nil {
		return c.SendStatus(a.Handler.ParserErrorCode)
	}

	if !request.Verify() {
		return c.SendStatus(501)
	}

	user.CreateSetting(a.Handler.Db)

	err := user.QueryUserId()
	if err != nil {
		if err == sql.ErrNoRows {
			user.InsertUser()
			user.MakeSEQ()
			response.AuthData = user.MakeAuthString()
			return c.JSON(response)
		}
	}

	response.ErrorMessage = model.ErrorEnum(model.Account_Create_Id_Already_Exists).String()
	return c.JSON(response)
}

type AccountLogin struct {
	Handler
}

func (a *AccountLogin) PostFunction(c *fiber.Ctx) error {

	user := db.GetSession()
	defer user.Release()

	request := &user.AccountLoginRequest
	response := &user.AccountLoginResponse

	if err := c.BodyParser(request); err != nil {
		return c.SendStatus(a.Handler.ParserErrorCode)
	}

	user.LoginSetting(a.Handler.Db)

	if nil == user.CheckUserIdAndPassWord() {
		user.MakeSEQ()
		response.AuthData = user.MakeAuthString()
		response.NickName = user.NickName
		response.EMail = user.EMail
		return c.JSON(response)
	}

	return c.SendStatus(501)
}
