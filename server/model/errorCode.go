package model

import "fmt"

type ErrorEnum int

const (
	Account_Create_Id_Already_Exists ErrorEnum = 1
	Bar                              ErrorEnum = 2
)

func (e ErrorEnum) String() string {
	switch e {
	case Account_Create_Id_Already_Exists:
		return "Account Create Id Already Exists"
	default:
		return fmt.Sprintf("%d", int(e))
	}
}
