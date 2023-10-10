import 'dart:convert';

import 'package:niko_client/model/account.dart';

import '../shared/constants.dart';
import 'http_service.dart';

class AccountService {
  Future<AccountCreateResponse?> registerUserWithIdandPassword(
      String id, String password) async {
    try {
      AccountCreateRequest request = AccountCreateRequest(id, password, null);
      String url = "${Constants.apiUrl}/api/account/create";
      String jsonString = jsonEncode(request);

      String responseString = await Post(url, jsonString);
      return AccountCreateResponse.fromJson(json.decode(responseString));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<AccountCreateResponse?> loginUser(String id, String password) async {
    try {
      AccountLoginRequest request = AccountLoginRequest(id, password, null);
      String url = "${Constants.apiUrl}/api/account/login";
      String jsonString = jsonEncode(request);

      String responseString = await Post(url, jsonString);
      return AccountCreateResponse.fromJson(json.decode(responseString));
    } catch (e) {
      print(e);
    }
    return null;
  }
}
