import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';

import '../model/User.dart';
import 'package:http/http.dart' as http;
class UserServices {
  static Future<http.Response> checkExistedPhone(String phone) async {
    final uri = Uri.parse("$baseUserUrl/user/$phone");
    http.Response response = await http.get(uri);
    return response;
  }

  static Future<http.Response> getUserDetailsByPhone(String phone) async {
    final uri = Uri.parse("$baseUserUrl/user/details/$phone");
    http.Response response = await http.get(uri);
    return response;
  }

  static Future<http.Response> register(User user) async {
    final uri = Uri.parse("$baseUserUrl/register" );

    http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(user)
    );
    return response;
  }

  static Future<http.Response> login(User user) async {
    final uri = Uri.parse("$baseUserUrl/login" );
    final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(user)
    );
    return response;
  }

  static Future<http.Response> updateUserDetail(User user) async {
    print(user);
    final uri = Uri.parse("$baseUserUrl/user/details-update" );
    print(jsonEncode(user));

    // final jsonEncoder =   JsonEncoder.withIndent(' ', (object) {
    //   if(object is DateTime?) {
    //     return object?.toIso8601String();
    //   }
    //   return null;
    // },);
    //
    // final jsonString = jsonEncoder.convert(user);

    final response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(user)
    );

    return response;
  }

}