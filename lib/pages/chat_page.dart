import 'dart:async';
import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/user_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatefulWidget {
  User currentUser;
  ConversationResponse conversationResponse;
  String conversationName;
  ChatPage(
      {super.key,
      required this.currentUser,
      required this.conversationResponse,
      required this.conversationName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String conversationName = "";
  User currentUser = User();
  List<Message> messages = [];
  List<User> userMemberDetails = [];
  final ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerListView = new ScrollController();

  @override
  void initState() {
    super.initState();
    conversationName = widget.conversationName;
    currentUser = widget.currentUser;
    messages = widget.conversationResponse.conversation!.messages!;
    userMemberDetails = widget.conversationResponse.memberDetails!;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void _scrollToEnd() {
    _scrollControllerListView.animateTo(
      _scrollControllerListView.position.maxScrollExtent*0.000000005,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeInOut,
    );
  }


  @override
  void dispose() {
    _scrollControllerListView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _textFieldController = TextEditingController();
    var height = size.height * 0.05;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: darkGreen,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            conversationName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.04),
          ),
          backgroundColor: lightGreen,
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: const Icon(
                  Icons.more_horiz_outlined,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: size.width * 0.01),
          child: Column(
            children: [
              Expanded(child: _buildMessageList(size, messages)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: lightGreen,
                        ),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Container(
                          height: height,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: TextField(
                              controller: _textFieldController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                _scrollController.jumpTo(
                                    _scrollController.position.maxScrollExtent);
                              },
                              decoration: const InputDecoration(
                                hintText: "Tin nhắn",
                                hintStyle: TextStyle(color: greyDark),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.image_outlined,
                              color: lightGreen,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.paperclip,
                              color: lightGreen,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.mic_fill,
                              color: lightGreen,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget? creatAva(Message message, Size size) {
    for (var mem in userMemberDetails) {
      if (mem.phone == message.sender_phone) {
        return FunctionService.createAvatar(
            mem.avatarUrl, size, mem.name!, CHAT);
      }
    }
  }

  String? getMemName(String sender_phone) {
    for (var mem in userMemberDetails) {
      if (mem.phone == sender_phone) {
        return mem.name;
      }
    }
  }

  Widget? MessageBubbleItem(Message message, Size size, User currentUser) {
    var memberLength =
        widget.conversationResponse.conversation!.members!.length;
    if (memberLength > 2) {
      return Row(
        mainAxisAlignment: (message.sender_phone != currentUser.phone) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.sender_phone != currentUser.phone)
            creatAva(message, size)!,
          Column(
            children: [
              if (message.sender_phone != currentUser.phone)
                Text(getMemName(message.sender_phone!)!),
              MessageBubble(
                message: message,
                currentUser: currentUser,
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: (message.sender_phone != currentUser.phone) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.sender_phone != currentUser.phone)
            creatAva(message, size)!,
          MessageBubble(
            message: message,
            currentUser: currentUser,
          ),
        ],
      );
    }
  }

  Widget _buildMessageList(Size size, List<Message> messages) {
    return ListView.builder(
      reverse: true,
      controller: _scrollControllerListView,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.01, right: size.width * 0.01),
            child: MessageBubbleItem(message, size, currentUser));
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  final Message message;
  final User currentUser;
  const MessageBubble(
      {super.key, required this.message, required this.currentUser});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Color backgroundTextColor = Colors.lightGreen;
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    String? sender_phone = widget.message.sender_phone;
    String? current_phone = widget.currentUser.phone;

    final size = MediaQuery.sizeOf(context);
    final alignment = (sender_phone == current_phone)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    backgroundTextColor = (sender_phone == current_phone)
        ? backgroundTextColor = lightGreen
        : backgroundTextColor = Colors.white;

    textColor = (sender_phone == current_phone)
        ? textColor = Colors.white
        : textColor = Colors.black;

    final textAlign = (sender_phone == current_phone)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return Align(
      alignment: alignment,
      child: Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.66),
          padding: EdgeInsets.all(size.width * 0.02),
          margin: EdgeInsets.all(size.width * 0.01),
          decoration: BoxDecoration(
              color: backgroundTextColor,
              borderRadius: BorderRadius.circular(size.width * 0.03)),
          child: Column(
            crossAxisAlignment: textAlign,
            children: [
              Text(
                widget.message.content ?? "",
                style: TextStyle(fontSize: size.width * 0.04, color: textColor),
              ),
              Text(
                "${widget.message.sent_date_time?.hour}:${widget.message.sent_date_time?.minute}",
                style: TextStyle(fontSize: size.width * 0.04, color: textColor),
              )
            ],
          )),
    );
  }
}
