import 'package:niko_client/model/base.dart';

class AccountCreateRequest extends RequsetBase {
  String id;
  String password;

  AccountCreateRequest(this.id, this.password, String? authData)
      : super(authData);

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Password': password,
    };
  }

  AccountCreateRequest.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        password = json['Password'],
        super(null);
}

class AccountCreateResponse extends ResponseBase {
  AccountCreateResponse(String errorMesage) : super(errorMesage);
  String authData = "";

  Map<String, dynamic> toJson() {
    return {
      'AuthData': authData,
      'ErrorMessage': errorMesage,
    };
  }

  AccountCreateResponse.fromJson(Map<String, dynamic> json)
      : authData = json['AuthData'],
        super(json['ErrorMessage']);
}

class AccountLoginRequest extends RequsetBase {
  String id;
  String password;

  AccountLoginRequest(this.id, this.password, String? authData)
      : super(authData);

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Password': password,
    };
  }

  AccountLoginRequest.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        password = json['Password'],
        super(null);
}

class AccountLoginResponse extends ResponseBase {
  AccountLoginResponse(String errorMesage) : super(errorMesage);
  String authData = "";

  Map<String, dynamic> toJson() {
    return {
      'AuthData': authData,
      'ErrorMessage': errorMesage,
    };
  }

  AccountLoginResponse.fromJson(Map<String, dynamic> json)
      : authData = json['AuthData'],
        super(json['ErrorMessage']);
}
