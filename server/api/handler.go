package api

import (
	"niko_server/db"

	"github.com/rs/zerolog/log"
)

type Handler struct {
	ParserErrorCode int
	*db.Db
}

func (h *Handler) SetHandler(serverHandler *Handler) {
	h.ParserErrorCode = serverHandler.ParserErrorCode
	h.Db = serverHandler.Db
}

func (h *Handler) Init(path string) {
	h.ParserErrorCode = 500

	h.Db = new(db.Db)
	h.Db.Init(path)

	if h.Db.CreateDB() != nil {
		log.Fatal().Msg("DB Create Error")
	}

}
