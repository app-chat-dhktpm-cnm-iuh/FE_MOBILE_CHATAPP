import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:http/http.dart' as http;
class FriendService {
  static Future<http.Response> getFriendListCurrentPhone(String? phone) async {
    final uri = Uri.parse("$baseUserUrl/user/friends/$phone");
    http.Response response = await http.get(uri);
    return response;
  }

  static Future<http.Response> getFriendRequestList(String? phone) async {
    final uri = Uri.parse("$baseUserUrl/user/friend-request/$phone");
    http.Response response = await http.get(uri);
    return response;
  }
}