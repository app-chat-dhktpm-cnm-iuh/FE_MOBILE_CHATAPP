import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:http/http.dart' as http;
class FriendService {
  static Future<http.Response> getFriendListCurrentPhone(String? phone) async {
    final uri = Uri.parse("$baseUserUrl/user/friends/$phone");
    http.Response reponse = await http.get(uri);
    return reponse;
  }
}