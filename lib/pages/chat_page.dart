import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Attach.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/MessageRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:video_player/video_player.dart';
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
  List<Attach> attaches = [];
  List<String> images = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerListView = ScrollController();
  final TextEditingController _textFieldController = TextEditingController();

  var sendFunctionVisible = true;
  var sendMessageVisible = false;
  List<Media> mediaList = [];
  final FocusNode _focusNode = FocusNode();

  bool _showEmojiPicker = false;
  bool _isOpenPicker = false;
  bool _showPreviewMedia = false;

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
            message_id: messageRequest.message_id,
            sent_date_time: messageRequest.sent_date_time,
            phoneDeleteList: messageRequest.phoneDeleteList,
            sender_avatar_url: messageRequest.sender_avatar_url,
            sender_phone: messageRequest.sender_phone,
            images: messageRequest.images,
            content: messageRequest.content,
            attaches: messageRequest.attaches,
            sender_name: messageRequest.sender_name,
            is_read: messageRequest.is_read,
            is_notification: messageRequest.is_notification);

        if (widget.conversationResponse.conversation?.conversation_id ==
            messageRequest.conversation_id) {
          messages.add(message);
          _scrollToEnd();
          setState(() {});
        }},
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

  Future<void> pickMedia() async {
    setState(() {
      _focusNode.unfocus();
      _showEmojiPicker = false;
      if (_isOpenPicker == false) {
        _isOpenPicker = true;
        if (_showPreviewMedia == true) {
          _showPreviewMedia = false;
        }
      } else {
        _isOpenPicker = false;
      }
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
                //Render Mesage List
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
                          onPressed: pickEmoji,
                        ),
                        //Input type chat
                        Expanded(
                          child: SizedBox(
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
                                onPressed: pickFile,
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

                                  String content = _textFieldController.text;



                                  messageRequest = messageRequest.copyWith(
                                      attaches: attaches,
                                      content: content,
                                      conversation_id: conversationID,
                                      members: members,
                                      images: images,
                                      sender_avatar_url: currentUser.avatarUrl,
                                      sender_name: senderName,
                                      sender_phone: senderPhone,
                                      sent_date_time: DateTime.now().toLocal(),
                                      is_read: false,
                                      is_notification: false);

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
                    child: SizedBox(
                      height: size.height * 0.4,
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
                            height: size.height * 0.25,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: size.width * 0.0001,
                                      mainAxisSpacing: size.width * 0.0001),
                              shrinkWrap: true,
                              itemCount: mediaList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
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
                                        margin:
                                            EdgeInsets.all(size.width * 0.025),
                                        child: SizedBox(
                                            width: size.width * 0.25,
                                            height: size.width * 0.25,
                                            child: MediaPreviewItem(
                                                mediaList[index - 1], size)),
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
                                                mediaList.removeAt(index - 1);
                                                if (mediaList.isEmpty) {
                                                  _showPreviewMedia = false;
                                                  if (sendMessageVisible == true) {
                                                    sendMessageVisible = false;
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
                          top: size.width * 0.35,
                          child: ElevatedButton(
                            onPressed: () async {
                              for (var media in mediaList) {
                                File? fileBytes = media.file;
                                String nameFile = media.file!.path.split('/').last;
                                Reference reference;
                                if(media.mediaType == MediaType.image) {
                                  reference = FirebaseStorage.instance
                                      .ref().child('chatImages/$nameFile');

                                  await reference.putFile(fileBytes!);

                                } else {
                                  reference = FirebaseStorage.instance
                                      .ref().child('chatVideos/$nameFile');

                                  await reference.putFile(fileBytes!);
                                }

                                
                                String imageUrl =
                                    await reference.getDownloadURL();
                                images.add(imageUrl);
                              }

                              MessageRequest messageRequest =
                              MessageRequest();

                              messageRequest = messageRequest.copyWith(
                                  attaches: attaches,
                                  conversation_id: conversationID,
                                  images: images,
                                  members: members,
                                  sender_avatar_url: currentUser.avatarUrl,
                                  sender_name: senderName,
                                  sender_phone: senderPhone,
                                  sent_date_time: DateTime.now().toLocal(),
                                  is_read: false,
                                  is_notification: false);
                              widget.stompManager.sendStompMessage(
                                  "/app/chat",
                                  const JsonEncoder()
                                      .convert(messageRequest.toJson()));
                              setState(() {
                                images.clear();
                                _showPreviewMedia = false;
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(lightGreen),
                                fixedSize: MaterialStateProperty.all(Size(
                                    size.width * 0.65, size.height * 0.06))),
                            child: Text(
                              "Gửi",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )),
                //Show Emoji Picker
                Visibility(
                  visible: _showEmojiPicker,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {},
                    config: Config(
                      height: size.height * 0.35,
                      checkPlatformCompatibility: true,
                      swapCategoryAndBottomBar: false,
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                    ),
                  ),
                )
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
                MessageBubble(message, currentUser, size),
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
                MessageBubble(message, currentUser, size),
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
            MessageBubble(message, currentUser, size),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (message.sender_phone != currentUser.phone &&
                message.sender_phone != null)
              creatAva(message, size)!,
            MessageBubble(message, currentUser, size),
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

  void pickFile() async {
    setState(() {
      _showEmojiPicker = false;
      _showPreviewMedia = false;
      _isOpenPicker = false;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'doc',
        'docx',
        'pdf',
        'txt',
        'xml',
        'ppt',
        'pptx',
        'xls',
        'xlsm',
        'rar',
        'zip',
      ],
    );
    if (result != null) {
      List<PlatformFile> files = result.files;
      String conversationID =
      widget.conversationResponse.conversation!.conversation_id!;

      List<String> members =
      widget.conversationResponse.conversation!.members!;

      String senderName = widget.currentUser.name!;
      String senderPhone = widget.currentUser.phone!;

      for (var file in files) {
        File fileData = File(file.path!);

        String nameFile = file.name;
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('chatAttachments/$nameFile');

        await reference.putFile(fileData);

        String filePath = await reference.getDownloadURL();
        Attach attach = Attach(url: filePath, name: nameFile);
        attaches.add(attach);
      }

      MessageRequest messageRequest = MessageRequest();

      messageRequest = messageRequest.copyWith(
          attaches: attaches,
          conversation_id: conversationID,
          images: images,
          members: members,
          sender_avatar_url: currentUser.avatarUrl,
          sender_name: senderName,
          sender_phone: senderPhone,
          sent_date_time: DateTime.now().toLocal(),
          is_read: false,
          is_notification: false);
      widget.stompManager.sendStompMessage(
          "/app/chat", const JsonEncoder().convert(messageRequest.toJson()));

      setState(() {
        attaches.clear();
      });
    }
  }

  void pickEmoji() {
    setState(() {
      if (_isOpenPicker == true) {
        _isOpenPicker = false;
      }
      if (_showEmojiPicker == false) {
        _showEmojiPicker = true;
      } else {
        _showEmojiPicker = false;
      }
    });
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

Widget MessageBubble(Message message, User currentUser, Size size) {
  String? sender_phone = message.sender_phone;
  String? current_phone = currentUser.phone;

  Color backgroundTextColor = Colors.lightGreen;
  Color textColor = Colors.black;
  var images = message.images;
  var attaches = message.attaches;
  String? content = message.content;
  var sent_date_time = message.sent_date_time;

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
    if (content != null) {
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
                  content,
                  style:
                      TextStyle(fontSize: size.width * 0.04, color: textColor),
                ),
                Text(
                  "${sent_date_time!.hour}:${sent_date_time.minute}",
                  style:
                      TextStyle(fontSize: size.width * 0.04, color: textColor),
                )
              ],
            )),
      );
    } else if (images!.isNotEmpty) {
      return Align(
        alignment: alignment,
        child: Column(children: [
          for (var imgUrl in images)
            FirebaseStorage.instance
                        .refFromURL(imgUrl)
                        .fullPath
                        .split("/")
                        .first == "chatImages"
                ? Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.66),
                    padding: EdgeInsets.all(size.width * 0.02),
                    margin: EdgeInsets.all(size.width * 0.01),
                    decoration: BoxDecoration(
                        color: backgroundTextColor,
                        borderRadius: BorderRadius.circular(size.width * 0.03)),
                    child: Column(
                      crossAxisAlignment: textAlign,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                        Text(
                          "${sent_date_time!.hour}:${sent_date_time.minute}",
                          style: TextStyle(
                              fontSize: size.width * 0.04, color: textColor),
                        )
                      ],
                    ))
                : Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.66),
                    padding: EdgeInsets.all(size.width * 0.02),
                    margin: EdgeInsets.all(size.width * 0.01),
                    decoration: BoxDecoration(
                        color: backgroundTextColor,
                        borderRadius: BorderRadius.circular(size.width * 0.03)),
                    child: Column(
                      crossAxisAlignment: textAlign,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [videoPlayerWidget(imgUrl)],
                        ),
                        Text(
                          "${sent_date_time!.hour}:${sent_date_time.minute}",
                          style: TextStyle(
                              fontSize: size.width * 0.04, color: textColor),
                        )
                      ],
                    ))
        ]),
      );
    } else if (attaches!.isNotEmpty) {
      return Column(
        children: [
          for (Attach attach in attaches)
            Container(
                constraints: BoxConstraints(maxWidth: size.width * 0.66),
                padding: EdgeInsets.all(size.width * 0.02),
                margin: EdgeInsets.all(size.width * 0.01),
                decoration: BoxDecoration(
                    color: backgroundTextColor,
                    borderRadius: BorderRadius.circular(size.width * 0.03)),
                child: Column(
                  children: [
                    Row(
                        children: [
                      Expanded(
                        child: SvgPicture.asset(
                          "assets/images/${getTypeFile(attach.name)}-icon.svg",
                          height: size.width*0.15,
                          width: size.width*0.15,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(attach.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width*0.035),),
                            InkWell(
                              onTap: () {},
                              child: Text("Nhấn để tải xuống", style: TextStyle(fontSize: size.width*0.035),),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Text(
                      "${sent_date_time!.hour}:${sent_date_time.minute}",
                      style: TextStyle(
                          fontSize: size.width * 0.04, color: textColor),
                    )
                  ],
                )),
        ],
      );
    }
  } else {
    return Align(
      alignment: Alignment.center,
      child: Text(content ?? "",
          style:
              TextStyle(fontSize: size.width * 0.04, color: Colors.blueGrey)),
    );
  }
  return Text("Hello");
}

String getTypeFile(String? nameFile) {
  String fileType = nameFile!.split('.').last;
  if(fileType == "png" || fileType == "svg" || fileType == "jpeg" || fileType == "jpg" || fileType == "gif") {
    return "picture";
  } else if(fileType == "docx") {
    return 'doc';
  } else if(fileType == "pptx") {
    return 'ppt';
  } else if (fileType == "xlsm") {
    return 'xls';
  } else if (fileType == "zip") {
    return 'rar';
  }
  return fileType;
}

Widget videoPlayerWidget(String imgUrl) {
  late VideoPlayerController videoController;
  late FlickManager flickManager;

  videoController = VideoPlayerController.contentUri(Uri.parse(imgUrl));
  flickManager = FlickManager(videoPlayerController: videoController);

  return FlickVideoPlayer(
    flickManager: flickManager,
  );
}
