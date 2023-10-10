import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> Post(String url, String body) async {
  Map<String, String> headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8',
  };

  final uri = Uri.parse(url);
  final response = await http.post(uri, body: body, headers: headers);

  final responseString = utf8.decode(response.bodyBytes);

  print('Response body: ${responseString}');

  return responseString;
}
