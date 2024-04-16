import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/chat_page.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/conversation_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/message_serviceImpl.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ChatsListWidget extends StatefulWidget {
  User currentUser;
  ChatsListWidget({super.key, required this.currentUser});

  @override
  State<ChatsListWidget> createState() => _ChatsListWidgetState();
}

class _ChatsListWidgetState extends State<ChatsListWidget> {
  List<Conversation?> _conversationList = [];
  List<ConversationResponse> _conversationListResponse = [];
  String phone_current = "";
  @override
  void initState() {
    super.initState();
    _conversationListResponse = [];
    _conversationList = [];
    phone_current = widget.currentUser.phone!;
    ConversationServiceImpl.getConversationOfCurrentUser(phone_current)
        .then((conversationResponse) => {
              setState(() {
                _conversationListResponse = conversationResponse;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    _conversationList = [];
    String? conversationName = "";
    // _conversationListResponse = [];
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    // for (var conv in _conversationListResponse) {
    //   _conversationList.add(conv.conversation);
    // }
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
                ConversationResponse? conversationResponse = _conversationListResponse[index];
                Conversation? conversation = conversationResponse.conversation;
                Message lastMessage = MessageServiceImpl.getLastMessage(
                    conversation?.messages!.toList());
                conversationName = ConversationServiceImpl.getNameConversation(conversationResponse, phone_current);
                return ListTile(
                  onTap: () {
                    conversationName = ConversationServiceImpl.getNameConversation(conversationResponse, phone_current);
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ChatPage(
                              currentUser: currentUser,
                              conversationResponse: conversationResponse,
                              conversationName: conversationName!,
                            ),
                            type: PageTransitionType.rightToLeft));
                  },
                  leading: FunctionService.createAvatar(
                      conversation!.ava_conversation_url?.toString(),
                      size,
                      conversationName.toString(),
                      LISTCHAT
                  ),
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
