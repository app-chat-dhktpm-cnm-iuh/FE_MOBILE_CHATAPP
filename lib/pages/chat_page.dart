import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Attach.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/MessageRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/message_serviceImpl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/stomp_manager.dart';

class ChatPage extends StatefulWidget {
  User currentUser;
  ConversationResponse conversationResponse;
  String conversationName;
  StompManager stompManager;
  ChatPage(
      {super.key,
      required this.currentUser,
      required this.conversationResponse,
      required this.conversationName,
        required this.stompManager
      });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String conversationName = "";
  User currentUser = User();
  List<Message> messages = [];
  List<User> userMemberDetails = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerListView = ScrollController();
  final TextEditingController _textFieldController = TextEditingController();

  var sendFunctionVisible = true;
  var sendMessageVisible = false;


  @override
  void initState() {
    super.initState();
    conversationName = widget.conversationName;
    currentUser = widget.currentUser;
    messages = widget.conversationResponse.conversation!.messages!;
    userMemberDetails = widget.conversationResponse.memberDetails!;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    //Update new message into list message of the conversation
    widget.stompManager.subscribeToDestination(
      "/user/${currentUser.phone}/queue/messages",
          (frame) {
        print("subscribe chat list");
        Map<String, dynamic> messageRequestJson = jsonDecode(frame.body!);
        MessageRequest messageRequest =
        MessageRequest.fromJson(messageRequestJson);
        Message message = Message();
        message = message.copyWith(
            sent_date_time: messageRequest.sent_date_time,
            sender_phone: messageRequest.sender_phone,
            content: messageRequest.content,
            attaches: messageRequest.attaches,
            sender_name: messageRequest.sender_name,
            is_read: messageRequest.is_read);
        if(widget.conversationResponse.conversation?.conversation_id == messageRequest.conversation_id) {
          // widget.conversationResponse.conversation?.messages?.add(message);
          messages.add(message);
          _scrollToEnd();
          setState(() {       });
          print("Conversation in if: " + MessageServiceImpl.getLastMessage(messages).toString());
        }

        print(messageRequest.toString());
      },
    );
  }

  void _scrollToEnd() {
    _scrollControllerListView.animateTo(
      _scrollControllerListView.position.maxScrollExtent + 500000000000000000,
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
    var height = size.height * 0.05;

    void handleChangeIcon () {
      if(_textFieldController.text == "") {
        setState(() {
          sendFunctionVisible = true;
          sendMessageVisible = false;
        });
      } else {
        setState(() {
          sendFunctionVisible = false;
          sendMessageVisible = true;
        });
      }
    }
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
                                handleChangeIcon();
                                _scrollController.jumpTo(
                                    _scrollController.position.maxScrollExtent*5000000);
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
                          Visibility(
                            visible: sendFunctionVisible,
                            child: IconButton(
                            icon: const Icon(
                              Icons.image_outlined,
                              color: lightGreen,
                            ),
                            onPressed: () {},
                          ),),
                          Visibility(
                            visible: sendFunctionVisible,
                            child: IconButton(
                            icon: const Icon(
                              CupertinoIcons.paperclip,
                              color: lightGreen,
                            ),
                            onPressed: () {},
                          ),),

                          Visibility(
                            visible: sendFunctionVisible,
                            child: IconButton(
                            icon: const Icon(
                              CupertinoIcons.mic_fill,
                              color: lightGreen,
                            ),
                            onPressed: () {},
                          ),),
                          Visibility(
                            visible: sendMessageVisible,
                            child: IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: lightGreen,
                            ),
                            onPressed: () {
                                MessageRequest messageRequest = MessageRequest();
                                List<Attach> attaches = [];
                                String content = _textFieldController.text;
                                String conversationID = widget.conversationResponse.conversation!.conversation_id!;
                                List<String> members = widget.conversationResponse.conversation!.members!;
                                String senderName = widget.currentUser.name!;
                                String senderPhone = widget.currentUser.phone!;

                                messageRequest = messageRequest.copyWith(
                                    attaches: attaches,
                                    content: content,
                                    conversation_id: conversationID,
                                    members: members,
                                    sender_name: senderName,
                                    sender_phone: senderPhone,
                                    sent_date_time: DateTime.now().toLocal(),
                                    is_read: false
                                );
                                widget.stompManager.sendStompMessage("/app/chat", JsonEncoder().convert(messageRequest.toJson()));
                                _textFieldController.clear();
                            },
                          ),),
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
      if(message.sender_phone != null) {
        return Row(
          mainAxisAlignment: (message.sender_phone != currentUser.phone)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (message.sender_phone != currentUser.phone && message.sender_phone != null)
              creatAva(message, size)!,
            Column(
              children: [
                if (message.sender_phone != currentUser.phone && message.sender_phone != null)
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                if (message.sender_phone != currentUser.phone && message.sender_phone != null)
                  Text(getMemName(message.sender_phone!)!),
                MessageBubble(
                  message: message,
                  currentUser: currentUser,
                ),
              ],
            ),
          ],
        );
      }

    } else {
      if(message.sender_phone != null) {
        return Row(
          mainAxisAlignment: (message.sender_phone != currentUser.phone)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (message.sender_phone != currentUser.phone)
              creatAva(message, size)!,
            MessageBubble(
              message: message,
              currentUser: currentUser,
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (message.sender_phone != currentUser.phone && message.sender_phone != null)
              creatAva(message, size)!,
            MessageBubble(
              message: message,
              currentUser: currentUser,
            ),
          ],
        );
      }

    }
  }

  Widget _buildMessageList(Size size, List<Message> messages) {
    return ListView.builder(
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
    var alignment = (sender_phone == current_phone)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    backgroundTextColor = (sender_phone == current_phone)
        ? backgroundTextColor = lightGreen
        : backgroundTextColor = Colors.white;

    textColor = (sender_phone == current_phone)
        ? textColor = Colors.white
        : textColor = Colors.black;

    var textAlign = (sender_phone == current_phone)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    if(sender_phone != null) {
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
                if(widget.message.content != null)
                  Text(
                    widget.message.content ?? "",
                    style: TextStyle(fontSize: size.width * 0.04, color: textColor),
                  ),
                if(widget.message.images!.isNotEmpty)
                  // ListView.builder(
                  //   scrollDirection: Axis.vertical,
                  //   shrinkWrap: true,
                  //   itemCount: widget.message.images!.length,
                  //   itemBuilder: (context, index) {
                  //     final imageUrl = widget.message.images?[index];
                  //     return Image.network(imageUrl!, fit: BoxFit.contain,);
                  //   },)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      for(var imgUrl in widget.message.images!)
                        Image.network(imgUrl, fit: BoxFit.cover,)

                    ],
                  )
                ,
                  Text(
                    "${widget.message.sent_date_time?.hour}:${widget.message.sent_date_time?.minute}",
                    style: TextStyle(fontSize: size.width * 0.04, color: textColor),
                  )
              ],
            )),
      );
    } else {
      return Align(
      alignment: Alignment.center,
      child: Text(
          widget.message.content ?? "",
          style: TextStyle(fontSize: size.width * 0.04, color: Colors.blueGrey)
      ),
    );
    }

  }
}
