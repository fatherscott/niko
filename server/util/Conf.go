package util

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/rs/zerolog/log"
)

// Conf 설정
type Conf struct {
	SqlitePath string
}

// Load 파일에서 설정값을 읽어 온다.
func (c *Conf) Load() {
	environment := os.Getenv("env")

	fileName := fmt.Sprintf("Conf.%s.json", environment)

	file, err := os.Open(fileName)
	if err == nil {
		decoder := json.NewDecoder(file)
		err := decoder.Decode(c)
		if err != nil {
			log.Fatal().Err(err).Msg("Read json")
		}
	}
}
