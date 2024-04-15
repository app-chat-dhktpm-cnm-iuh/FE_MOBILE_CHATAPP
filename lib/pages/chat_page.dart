import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  User currentUser;
  Conversation conversation;
  String conversationName;
  ChatPage(
      {super.key,
      required this.currentUser,
      required this.conversation,
      required this.conversationName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String conversationName = "";
  User currentUser = User();

  @override
  void initState() {
    super.initState();
    conversationName = widget.conversationName;
    currentUser = widget.currentUser;
    print("Conversation at chat page: ${widget.conversation}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conversationName),
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList())],
      ),
    );
  }

  Widget _buildMessageList() {
    String sender_phone = currentUser.phone!;
    return Text("hello");
  }
}
