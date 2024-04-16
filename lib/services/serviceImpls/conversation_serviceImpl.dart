import 'dart:convert';

import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/services/conversation_service.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';

import '../../model/User.dart';

class ConversationServiceImpl {
  static Future<List<ConversationResponse>> getConversationOfCurrentUser(
      String? phone) async {
    List<ConversationResponse> conversationsResponse = [];
    List<dynamic> conversationDynamic;
    String responseBody = "";
    await ConversationService.getListConversation(phone)
        .then((conversation) => {
              responseBody = utf8.decode(conversation.bodyBytes),
              conversationDynamic = jsonDecode(responseBody),
              conversationsResponse = conversationDynamic
                  .map((conversation) =>
                      ConversationResponse.fromJson(conversation))
                  .toList(),
            });
    return conversationsResponse;
  }

  static String? getNameConversation(
      ConversationResponse conversationResponse, String current_phone) {
    Conversation? conversation = conversationResponse.conversation;
    List<User>? memberDetails = conversationResponse.memberDetails;
    String? conversationName = "";
    if (memberDetails!.length > 2) {
      return conversation?.title;
    } else {
      memberDetails.forEach((member) {
        if (member.phone != current_phone) {
          conversationName = member.name;
        }
      });
      return conversationName;
    }
  }
}
