package db

import (
	"database/sql"
	"errors"
	"os"

	_ "github.com/mattn/go-sqlite3"

	"github.com/rs/zerolog/log"
)

type Db struct {
	Path       string
	CreateStmt string

	DB *sql.DB
}

func (d *Db) Init(path string) {
	d.Path = path

	d.CreateStmt = `
		create table user (id text not null primary key, pass_word text not null, nick_name text not null, e_mail text not null, created_at text default null);
	`
}

func (d *Db) DeleteDB() {
	os.Remove(d.Path)
}

func (d *Db) CreateDB() error {

	if _, err := os.Stat(d.Path); errors.Is(err, os.ErrNotExist) {

		db, err := d.GetDB()
		if err != nil {
			return err
		}
		defer d.Close()

		_, err = db.Exec(d.CreateStmt)
		if err != nil {
			log.Info().Err(err).Str("sqlStmt", d.CreateStmt).Msg("CreateDB")
			return err
		}
	}
	return nil
}

func (d *Db) GetDB() (*sql.DB, error) {
	if d.DB != nil {
		return d.DB, nil
	}

	db, err := sql.Open("sqlite3", d.Path)
	if err != nil {
		log.Info().Err(err).Msg("CreateDB")
		return nil, err
	}
	d.DB = db
	return d.DB, nil
}

func (d *Db) Close() error {
	d.DB.Close()
	d.DB = nil
	return nil
}

func (d *Db) Begin(db *sql.DB) (*sql.Tx, error) {
	tx, err := db.Begin()
	if err != nil {
		log.Info().Err(err).Msg("Begin")
		return nil, err
	}
	return tx, nil
}

func (d *Db) Commit(tx *sql.Tx) error {
	return tx.Commit()
}

func (d *Db) PrepareTx(tx *sql.Tx, sql string) (*sql.Stmt, error) {
	stmt, err := tx.Prepare(sql)
	if err != nil {
		log.Info().Err(err).Str("sql", sql).Msg("Prepare")
		return nil, err
	}
	return stmt, nil
}

func (d *Db) PrepareDb(db *sql.DB, sql string) (*sql.Stmt, error) {
	stmt, err := db.Prepare(sql)
	if err != nil {
		log.Info().Err(err).Str("sql", sql).Msg("Prepare")
		return nil, err
	}
	return stmt, nil
}

func (d *Db) Exec(stmt *sql.Stmt, args ...any) error {
	_, err := stmt.Exec(args...)
	if err != nil {
		log.Info().Err(err).Msg("Exec")
		return err
	}
	return nil
}

func (d *Db) Query(db *sql.DB, sql string, args ...any) (*sql.Rows, error) {
	rows, err := db.Query(sql, args...)
	if err != nil {
		log.Info().Err(err).Str("sql", sql).Msg("Query")
		return nil, err
	}
	return rows, nil
}
