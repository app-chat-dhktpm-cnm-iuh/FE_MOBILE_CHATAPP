import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/MessageRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/chat_page.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/conversation_service.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/conversation_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/message_serviceImpl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../services/stomp_manager.dart';

class ChatsListWidget extends StatefulWidget {
  User currentUser;
  final StompManager stompManager;
  ChatsListWidget(
      {super.key, required this.currentUser, required this.stompManager});

  @override
  State<ChatsListWidget> createState() => _ChatsListWidgetState();
}

class _ChatsListWidgetState extends State<ChatsListWidget> {
  List<ConversationResponse> _conversationListResponse = [];
  String phone_current = "";
  List<String> _conversationIdList = [];
  @override
  void initState() {
    super.initState();
    phone_current = widget.currentUser.phone!;
    widget.stompManager.subscribeToDestination(
        "/user/${currentUser.phone}/queue/chat", (frame) {
      print("Subcribe queue chat");
      Map<String, dynamic> conversationResponseJson = jsonDecode(frame.body!);

      ConversationResponse conversationResponse =
      ConversationResponse.fromJson(conversationResponseJson);

      for (var conversationResponseItem in _conversationListResponse) {
        _conversationIdList.add(conversationResponseItem.conversation!.conversation_id.toString());
      }

      if(_conversationIdList.contains(conversationResponse.conversation!.conversation_id)) {
        setState(() {
          for (var conversationResponseItem in _conversationListResponse) {
            if(conversationResponseItem.conversation!.conversation_id == conversationResponse.conversation!.conversation_id) {
              conversationResponseItem.conversation?.messages = conversationResponse.conversation?.messages;
              conversationResponseItem.conversation?.updated_at = conversationResponse.conversation?.updated_at;
            }
          }
        });

        sortListConversation();
      } else {
        _conversationListResponse.add(conversationResponse);
        _conversationListResponse = _conversationListResponse;
      }
    });
    ConversationServiceImpl.getConversationOfCurrentUser(phone_current)
        .then((conversationResponse) => {
              setState(() {
                _conversationListResponse = conversationResponse;
              })
            });
  }

  void sortListConversation() {
    setState(() {
      _conversationListResponse.sort((a, b) => b.conversation!.updated_at!.compareTo(a.conversation!.updated_at!));
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    _conversationListResponse.forEach((element) { print("build ${element.conversation!.conversation_id} ${element.conversation!.updated_at}");});
    String? conversationName = "";
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _conversationListResponse.length,
              itemBuilder: (context, index) {
                ConversationResponse? conversationResponse =
                _conversationListResponse[index];

                Conversation? conversation = conversationResponse.conversation;
                Message lastMessage = MessageServiceImpl.getLastMessage(
                    conversation?.messages!.toList());

                conversationName = ConversationServiceImpl.getNameConversation(
                    conversationResponse, phone_current);

                late String? conversationAvatar = conversation!.ava_conversation_url.toString();

                if(conversation!.members!.length > 2){
                  conversationAvatar = conversation.ava_conversation_url.toString();
                } else {
                  conversationResponse.memberDetails?.forEach((member) {
                    if(member.phone != currentUser.phone) {
                      conversationAvatar = member.avatarUrl;
                    }
                  });
                }

                return ListTile(
                  onTap: () {
                    conversationName =
                        ConversationServiceImpl.getNameConversation(
                            conversationResponse, phone_current);
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ChatPage(
                              currentUser: currentUser,
                              conversationResponse: conversationResponse,
                              conversationName: conversationName!,
                              stompManager: widget.stompManager,
                            ),
                            type: PageTransitionType.rightToLeft));
                  },
                  leading: FunctionService.createAvatar(
                      conversationAvatar,
                      size,
                      conversationName.toString(),
                      LISTCHAT),
                  title: Text(
                    conversationName.toString(),
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),
                  subtitle: Text(
                    lastMessage.content.toString(),
                    style: TextStyle(
                        color: greyDark, fontSize: size.width * 0.035),
                  ),
                  trailing: Text(
                    FunctionService.dateFormat(
                            lastMessage.sent_date_time!.toLocal())
                        .toString(),
                    style: TextStyle(
                        color: greyDark,
                        fontWeight: FontWeight.normal,
                        fontSize: size.width * 0.035),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
