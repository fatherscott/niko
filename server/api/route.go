package api

import (
	"github.com/gofiber/fiber/v2"
)

var PostFunctions map[string]PostFunctionInterface
var GetFunctions map[string]GetFunctionInterface

func isFunctionHashCreated() {

	if PostFunctions == nil {
		PostFunctions = make(map[string]PostFunctionInterface)
	}
	if GetFunctions == nil {
		GetFunctions = make(map[string]GetFunctionInterface)
	}
}

type Route struct {
}

func (r *Route) Init(app *fiber.App, path string) {

	handler := new(Handler)
	handler.Init(path)

	for k, v := range PostFunctions {
		app.Post(k, v.PostFunction)
		v.SetHandler(handler)
	}
}
