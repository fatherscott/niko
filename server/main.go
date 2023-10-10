package main

import (
	"niko_server/api"
	"niko_server/util"

	"github.com/gofiber/fiber/v2"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	zerolog.SetGlobalLevel(zerolog.TraceLevel)
	log.Info().Stack().Msg("niko_server start...")

	conf := new(util.Conf)
	conf.Load()

	app := fiber.New()

	route := new(api.Route)
	route.Init(app, conf.SqlitePath)

	err := app.Listen(":3000")
	if err != nil {
		log.Fatal().Msg(err.Error())
	}

}
