import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';

import '../model/User.dart';
import 'package:http/http.dart' as http;
class UserServices {
  static Future<http.Response> checkExistedPhone(String phone) async {
    final uri = Uri.parse("$baseUserUrl/user/$phone");
    http.Response reponse = await http.get(uri);
    return reponse;
  }

  static Future<http.Response> getUserDetailsByphone(String phone) async {
    final uri = Uri.parse("$baseUserUrl/user/details/$phone");
    http.Response reponse = await http.get(uri);
    return reponse;
  }

  static Future<http.Response> register(User user) async {
    final uri = Uri.parse("$baseUserUrl/register" );

    http.Response reponse = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(user)
    );
    return reponse;
  }

  static Future<http.Response> login(User user) async {
    final uri = Uri.parse("$baseUserUrl/login" );
    final reponse = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(user)
    );
    print(reponse.statusCode);
    return reponse;
  }
}