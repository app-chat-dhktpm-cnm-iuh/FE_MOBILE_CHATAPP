import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:http/http.dart' as http;
class ConversationService {

  static Future<http.Response> getListConversation(String? phone) async {
    final uri = Uri.parse("$baseUserUrl/user/messages/$phone");
    http.Response reponse = await http.get(uri);
    return reponse;
  }


}