import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:niko_client/model/account.dart';

import '../shared/constants.dart';
import 'http_service.dart';

class AccountService {
  Future<AccountCreateResponse?> registerUserWithIdandPassword(
      String id, String password, String nickName, String eMail) async {
    try {
      AccountCreateRequest request =
          AccountCreateRequest(id, password, nickName, eMail);
      String url = "${Constants.apiUrl}/api/account/create";
      String jsonString = jsonEncode(request);

      String responseString = await Post(url, jsonString);
      return AccountCreateResponse.fromJson(json.decode(responseString));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<AccountLoginResponse?> loginUser(String id, String password) async {
    try {
      AccountLoginRequest request = AccountLoginRequest(id, password, null);
      String url = "${Constants.apiUrl}/api/account/login";
      String jsonString = jsonEncode(request);

      String responseString = await Post(url, jsonString);
      return AccountLoginResponse.fromJson(json.decode(responseString));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<AccountLoginResponse?> getGroup(String id) async {
    try {
      AccountLoginRequest request = AccountLoginRequest(id, password, null);
      String url = "${Constants.apiUrl}/api/account/login";
      String jsonString = jsonEncode(request);

      String responseString = await Post(url, jsonString);
      return AccountLoginResponse.fromJson(json.decode(responseString));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
