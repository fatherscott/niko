package model

type RequestBase struct {
	AuthData string `json: "AuthData"`
}

func (b *RequestBase) Reset() {
	b.AuthData = ""
}

type ResponseBase struct {
	ErrorMessage string `json: "ErrorMessage"`
}

func (b *ResponseBase) Reset() {
	b.ErrorMessage = ""
}
