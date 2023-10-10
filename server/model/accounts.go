package model

type AccountCreateRequest struct {
	RequestBase
	Id       string `json: "Id"`
	Password string `json: "Password"`
}

func (request *AccountCreateRequest) Reset() {
	request.RequestBase.Reset()
	request.Id = ""
	request.Password = ""
}

func (a *AccountCreateRequest) Verify() bool {
	if len(a.Id) < 1 {
		return false
	}
	if len(a.Password) < 1 {
		return false
	}
	return true
}

type AccountCreateResponse struct {
	ResponseBase
	AuthData string `json: "AuthData"`
}

func (response *AccountCreateResponse) Reset() {
	response.ResponseBase.Reset()
	response.AuthData = ""
}

type AccountLoginRequest struct {
	Id       string `json: "Id"`
	Password string `json: "password"`
}

func (request *AccountLoginRequest) Reset() {
	request.Id = ""
	request.Password = ""
}

type AccountLoginResponse struct {
	ResponseBase
	AuthData string `json: "AuthData"`
}

func (response *AccountLoginResponse) Reset() {
	response.ResponseBase.Reset()
	response.AuthData = ""
}
