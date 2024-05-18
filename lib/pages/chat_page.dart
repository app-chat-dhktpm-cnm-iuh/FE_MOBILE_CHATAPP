import 'dart:convert';
import 'dart:ui';

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
import 'package:flutter/widgets.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
      required this.stompManager});

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
  List<Media> mediaList = [];
  final FocusNode _focusNode = FocusNode();

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
        if (widget.conversationResponse.conversation?.conversation_id ==
            messageRequest.conversation_id) {
          // widget.conversationResponse.conversation?.messages?.add(message);
          messages.add(message);
          _scrollToEnd();
          setState(() {});
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

  List<MediaFile> selectedMedias = [];
  bool _isOpenPicker = false;
  bool _showPreviewMedia = false;
  late List<MediaFile>? medias;
  Future<void> pickMedia() async {
    setState(() {
      _focusNode.unfocus();
      if (_isOpenPicker == false) {
        _isOpenPicker = true;
        if (_showPreviewMedia == true) {
          _showPreviewMedia = false;
        }
        if (sendMessageVisible == true) {
          sendMessageVisible = false;
        }
      } else
        _isOpenPicker = false;
    });
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

    void handleChangeIcon() {
      if (_textFieldController.text == "") {
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
          //Icon back
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
          //Conversation name
          title: Text(
            conversationName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.04),
          ),
          backgroundColor: lightGreen,
          actions: [
            //Icon voice call
            IconButton(
                icon: const Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                onPressed: () {}),
            //Icon video call
            IconButton(
                icon: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
                onPressed: () {}),
            //Icon more infomation chat
            IconButton(
                icon: const Icon(
                  Icons.more_horiz_outlined,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Padding(
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
                        //Emoji button
                        IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: lightGreen,
                          ),
                          onPressed: () {},
                        ),
                        //Input type chat
                        Expanded(
                          child: Container(
                            height: height,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: TextField(
                                controller: _textFieldController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                focusNode: _focusNode,
                                onTap: () {
                                  setState(() {
                                    _showPreviewMedia = false;
                                    _isOpenPicker = false;
                                    mediaList.clear();
                                  });
                                },
                                onChanged: (value) {
                                  handleChangeIcon();
                                  _scrollController.jumpTo(_scrollController
                                          .position.maxScrollExtent *
                                      5000000);
                                  setState(() {
                                    _showPreviewMedia = false;
                                    mediaList.clear();
                                  });
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
                            //Send Image Button
                            Visibility(
                              visible: sendFunctionVisible,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.image_outlined,
                                  color: lightGreen,
                                ),
                                onPressed: pickMedia,
                              ),
                            ),
                            //Send Attach Button
                            Visibility(
                              visible: sendFunctionVisible,
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.paperclip,
                                  color: lightGreen,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            //Send voice recorder button
                            Visibility(
                              visible: sendFunctionVisible,
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.mic_fill,
                                  color: lightGreen,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            //Send message button
                            Visibility(
                              visible: sendMessageVisible,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: lightGreen,
                                ),
                                onPressed: () {
                                  MessageRequest messageRequest =
                                      MessageRequest();
                                  List<Attach> attaches = [];
                                  String content = _textFieldController.text;
                                  String conversationID = widget
                                      .conversationResponse
                                      .conversation!
                                      .conversation_id!;
                                  List<String> members = widget
                                      .conversationResponse
                                      .conversation!
                                      .members!;
                                  String senderName = widget.currentUser.name!;
                                  String senderPhone =
                                      widget.currentUser.phone!;

                                  messageRequest = messageRequest.copyWith(
                                      attaches: attaches,
                                      content: content,
                                      conversation_id: conversationID,
                                      members: members,
                                      sender_name: senderName,
                                      sender_phone: senderPhone,
                                      sent_date_time: DateTime.now().toLocal(),
                                      is_read: false);
                                  widget.stompManager.sendStompMessage(
                                      "/app/chat",
                                      JsonEncoder()
                                          .convert(messageRequest.toJson()));
                                  _textFieldController.clear();
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Show image picker
                Visibility(
                    visible: _isOpenPicker,
                    child: Container(
                      height: 450,
                      child: MediaPicker(
                        mediaList: mediaList,
                        onPicked: (selectedList) {
                          setState(() {
                            mediaList = selectedList;
                            _isOpenPicker = false;
                            _showPreviewMedia = true;
                          });
                        },
                        onCancel: () => {
                          setState(() {
                            _isOpenPicker = false;
                            if (mediaList.isNotEmpty) {
                              _showPreviewMedia = true;
                              if (sendMessageVisible == false) {
                                sendMessageVisible = true;
                              }
                            }
                          })
                        },
                        decoration: PickerDecoration(
                          cancelIcon: const Icon(
                            CupertinoIcons.clear,
                            color: darkGreen,
                          ),
                          completeText: "Chọn",
                          completeButtonStyle: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(lightGreen)),
                          counterBuilder: (context, index) {
                            if (index == null) return const SizedBox();
                            return Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.001,
                                    right: size.width * 0.01),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: lightGreen,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(size.width * 0.015),
                                  child: Text(
                                    "$index",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )),
                //Show image preview
                Visibility(
                    visible: _showPreviewMedia,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: size.height*0.25,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: size.width*0.0001,
                                  mainAxisSpacing: size.width*0.0001
                              ),
                              shrinkWrap: true,
                              itemCount: mediaList.length+1,
                              itemBuilder: (context, index) {
                                if(index == 0) {
                                  return IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showPreviewMedia = false;
                                          _isOpenPicker = true;
                                          sendMessageVisible = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: lightGreen,
                                      ));
                                } else {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(
                                            size.width * 0.025),
                                        child: SizedBox(
                                            width: size.width * 0.25,
                                            height: size.width * 0.25,
                                            child: MediaPreviewItem(
                                                mediaList[index-1],
                                                size)),
                                      ),
                                      PositionedDirectional(
                                          end: -size.width * 0.004,
                                          top: -size.width * 0.015,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: lightGreen,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                mediaList
                                                    .removeAt(index-1);
                                                if (mediaList
                                                    .isEmpty) {
                                                  _showPreviewMedia =
                                                  false;
                                                  if (sendMessageVisible ==
                                                      true) {
                                                    sendMessageVisible =
                                                    false;
                                                  }
                                                }
                                              });
                                            },
                                          ))
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: size.width*0.35,
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(lightGreen),
                              fixedSize: MaterialStateProperty.all(
                                  Size(size.width * 0.65, size.height * 0.06))
                            ),
                            child: Text("Gửi",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
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
      if (message.sender_phone != null) {
        return Row(
          mainAxisAlignment: (message.sender_phone != currentUser.phone)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (message.sender_phone != currentUser.phone &&
                message.sender_phone != null)
              creatAva(message, size)!,
            Column(
              children: [
                if (message.sender_phone != currentUser.phone &&
                    message.sender_phone != null)
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
                if (message.sender_phone != currentUser.phone &&
                    message.sender_phone != null)
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
      if (message.sender_phone != null) {
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
            if (message.sender_phone != currentUser.phone &&
                message.sender_phone != null)
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

Widget MediaPreviewItem(Media mediaItem, Size size) {
  if (mediaItem.mediaType.toString() == "MediaType.video") {
    return Container(
      color: Colors.black54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.memory(
            mediaItem.thumbnail!,
          ),
          Icon(
            Icons.play_circle_outline,
            size: size.width * 0.05,
            color: Colors.white,
          ),
          Positioned.fill(
              top: size.width * 0.2,
              left: size.width * 0.15,
              child: Text(
                _printDuration(mediaItem.videoDuration),
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  } else {
    return Image.memory(
      mediaItem.thumbnail!,
      fit: BoxFit.cover,
    );
  }
}

String _printDuration(Duration? duration) {
  if (duration == null) return "";
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours == 0) return "$twoDigitMinutes:$twoDigitSeconds";
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
    if (sender_phone != null) {
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
                if (widget.message.content != null)
                  Text(
                    widget.message.content ?? "",
                    style: TextStyle(
                        fontSize: size.width * 0.04, color: textColor),
                  ),
                if (widget.message.images!.isNotEmpty)
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
                      for (var imgUrl in widget.message.images!)
                        Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                        )
                    ],
                  ),
                Text(
                  "${widget.message.sent_date_time?.hour}:${widget.message.sent_date_time?.minute}",
                  style:
                      TextStyle(fontSize: size.width * 0.04, color: textColor),
                )
              ],
            )),
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Text(widget.message.content ?? "",
            style:
                TextStyle(fontSize: size.width * 0.04, color: Colors.blueGrey)),
      );
    }
  }
}
