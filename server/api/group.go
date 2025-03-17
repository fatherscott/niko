package api

import (
	"database/sql"
	"niko_server/db"
	"niko_server/model"

	"github.com/gofiber/fiber/v2"
)

func init() {
	isFunctionHashCreated()
	GetFunctions["/api/group/list"] = new(GroupList)

}

type GroupList struct {
	Handler
}

func (a *GroupList) GetFunction(c *fiber.Ctx) error {

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
