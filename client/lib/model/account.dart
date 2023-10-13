import 'package:niko_client/model/base.dart';

class AccountCreateRequest extends RequsetBase {
  String id;
  String password;
  String nickName;
  String eMail;

  AccountCreateRequest(this.id, this.password, this.nickName, this.eMail)
      : super(null);

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Password': password,
      'NickName': nickName,
      'EMail': eMail,
    };
  }

  AccountCreateRequest.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        password = json['Password'],
        nickName = json['NickName'],
        eMail = json['EMail'],
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
  String nickName = "";
  String eMail = "";

  Map<String, dynamic> toJson() {
    return {
      'AuthData': authData,
      'NickName': nickName,
      'EMail': eMail,
      'ErrorMessage': errorMesage,
    };
  }

  AccountLoginResponse.fromJson(Map<String, dynamic> json)
      : authData = json['AuthData'],
        nickName = json['NickName'],
        eMail = json['EMail'],
        super(json['ErrorMessage']);
}
