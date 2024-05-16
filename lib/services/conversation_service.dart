import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:http/http.dart' as http;

import '../model/ConversationResponse.dart';
class ConversationService {

  static Future<http.Response> getListConversation(String? phone) async {
    final uri = Uri.parse("$baseUserUrl/user/messages/$phone");
    http.Response reponse = await http.get(uri);
    return reponse;
  }

  static List<ConversationResponse> sortListConversation(List<ConversationResponse> conversationResponseList) {
    conversationResponseList.sort((a, b) => b.conversation!.updated_at!.compareTo(a.conversation!.updated_at!));
    print(conversationResponseList);
    return conversationResponseList;
  }

}