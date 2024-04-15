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

  static Future<String?> getNameConversation(
      Conversation conversation, String current_phone) async {
    User user = User();
    String body = "";
    String phoneMem = conversation.members!.first.toString();
    dynamic detailDynamic;

    if (conversation.title?.compareTo("") == 1 || conversation.title == null) {
      if (conversation.creator_phone == current_phone) {
        await UserServices.getUserDetailsByphone(phoneMem).then((detail) => {
              body = utf8.decode(detail.bodyBytes),
              detailDynamic = jsonDecode(body),
              user = User.fromJson(detailDynamic)
            });
        return user.name;
      } else {
        await UserServices.getUserDetailsByphone(current_phone)
            .then((detail) => {
                  body = utf8.decode(detail.bodyBytes),
                  detailDynamic = jsonDecode(body),
                  user = User.fromJson(detailDynamic)
                });
        return user.name;
      }
    } else
      return conversation.title;
  }
}
