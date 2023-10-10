package api

import "github.com/gofiber/fiber/v2"

type PostFunctionInterface interface {
	PostFunction(c *fiber.Ctx) error
	SetHandler(h *Handler)
}

type GetFunctionInterface interface {
	GetFunction(c *fiber.Ctx) error
	SetHandler(h *Handler)
}
