import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/DeleteConversationUser.dart';
import 'package:fe_mobile_chat_app/model/Friend.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/conversation_service.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/conversation_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/user_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:page_transition/page_transition.dart';

class CreateGroupChatPage extends StatefulWidget {
  final StompManager stompManager;
  final UserToken userToken;

  const CreateGroupChatPage(
      {super.key, required this.stompManager, required this.userToken});

  @override
  State<CreateGroupChatPage> createState() => _CreateGroupChatPageState();
}

class _CreateGroupChatPageState extends State<CreateGroupChatPage> {
  UserToken userWithToken = UserToken();
  List<User> friendList = [];
  List<bool> isChecked = [];
  List<bool> isCheckedInSearch = [];
  List<User> memberList = [];
  List<User> friendListSearch = [];
  List<FriendRequest> friendRequests = [];
  bool showListMember = false;
  bool _isOpenPicker = false;
  bool showButtonPickImage = true;
  bool showAvatar = false;
  bool showFriendList = true;
  bool showFriendSearchResult = false;


  List<Media> mediaList = [];
  late Media avatarGroupChat = Media(id: "1");
  Uint8List imageAvatar = Uint8List(8);
  TextEditingController groupNameController = TextEditingController();
  TextEditingController searchFriendController = TextEditingController();
  String groupName = "";
  @override
  void initState() {
    super.initState();
    userWithToken = widget.userToken;
    FriendServiceImpl.getFriendListOfCurrentUser(currentUser.phone)
        .then((friends) => {
              setState(() {
                friendList = friends;
                isChecked = List.generate(friendList.length, (_) => false);
              })
            });
    FriendServiceImpl.getFriendRequestList(currentUser.phone)
        .then((friendRequestLists) => {
      setState(() {
        friendRequests = friendRequestLists;
      })
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: lightGreen,
          leadingWidth: size.width * 0.08,
          leading: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.02)),
                    title: Text("Lưu ý",
                        style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold)),
                    // titlePadding: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: size.width*0.02),
                    content: Text(
                      "Bạn có chắc chắn thoát ?",
                      style: TextStyle(fontSize: size.width * 0.04),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.width * 0.02),
                    backgroundColor: backgroundColor,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => false);
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: MainChat(
                                    stompManager: widget.stompManager,
                                    userToken: userWithToken,
                                    friendRequests: friendRequests,
                                    friends: friendList,
                                  ),
                                  type: PageTransitionType.fade,));
                        },
                        child: Text(
                          "Thoát",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: size.width * 0.04),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Ở lại",
                            style: TextStyle(
                                color: lightGreen, fontSize: size.width * 0.04),
                          ))
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: size.width * 0.05,
              )),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text("Tạo nhóm chat mới",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold)),
                if(memberList.isNotEmpty)
                Text("Đã chọn ${memberList.length} thành viên",
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width * 0.035))
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only( top: size.width*0.02, bottom: size.width*0.03),
                    child: Row(
                      children: [
                        Visibility(
                          visible: showButtonPickImage,
                          child: Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isOpenPicker = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    color: lightGreen,
                                    size: size.width * 0.1,
                                  ),
                                highlightColor: backgroundColor,
                              )
                          ),
                        ),
                        Visibility(
                          visible: showAvatar,
                          child: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if(_isOpenPicker == true) {
                                      _isOpenPicker = false;
                                    } else {
                                      _isOpenPicker = true;

                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(imageAvatar),
                                  radius: size.width*0.06,
                                ),
                              )
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: TextField(
                              controller: groupNameController,
                              onChanged: (value) {
                                setState(() {
                                  groupName = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Đặt tên nhóm",
                                  hintStyle: TextStyle(
                                    fontSize: size.width * 0.045,
                                    color: Colors.black38,
                                  ),
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none))),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextField(
                      controller: searchFriendController,
                      onChanged: (searchValue) async {
                        List<User> listFriendResult = [];
                        for(User friend in friendList) {
                          if(friend.name == searchValue) {
                            listFriendResult.add(friend);
                          }
                        }
                        if(listFriendResult.isEmpty) {
                          if(searchValue != userWithToken.user!.phone) {
                            await UserServices.getUserDetailsByPhone(searchValue).then((frame) {
                              Map<String, dynamic> friendJson = jsonDecode(frame.body);
                              User friend = User.fromJson(friendJson);
                              listFriendResult.add(friend);
                            }).catchError((error) {
                              listFriendResult = [];
                            });
                          }
                        }
                        setState(() {
                          if(searchFriendController.text.isNotEmpty) {
                              friendListSearch = listFriendResult;
                              isCheckedInSearch = List.generate(friendListSearch.length, (_) => false);
                              List<String> memPhone = [];
                              for (var mem in memberList) {
                                memPhone.add(mem.phone!);
                              }
                              for(User friendSearch in friendListSearch) {
                                if(memPhone.contains(friendSearch.phone)) {
                                  var index = friendListSearch.indexOf(friendSearch);
                                  isCheckedInSearch[index] = true;
                                }
                              }
                              showFriendSearchResult = true;
                              showFriendList = false;
                          } else {
                            showFriendSearchResult = false;
                            showFriendList = true;
                            friendListSearch = listFriendResult;
                          }
                        });
                      },
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black26,
                          ),
                          contentPadding: EdgeInsets.all(size.height * 0.01),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.normal,
                              color: Colors.black26),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black12,
                                width: size.width * 0.0035),
                            borderRadius: BorderRadius.circular(size.width),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black12,
                                width: size.width * 0.0035),
                            borderRadius: BorderRadius.circular(size.width),
                          )),
                    ),
                  ),

                  Visibility(
                    visible: showFriendList,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: size.width * 0.04,
                                top: size.width * 0.02,
                                bottom: size.width * 0.03),
                            child: Text(
                              "Bạn bè",
                              style: TextStyle(fontSize: size.width * 0.04),
                            ),
                          ),
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendList.length,
                          itemBuilder: (context, index) {
                            User user = friendList[index];
                            return ListTile(
                              leading: FunctionService.createAvatar(
                                  user.avatarUrl, size, user.name!, LISTCHAT),
                              title: Text(
                                user.name!,
                                style: TextStyle(fontSize: size.width * 0.04),
                              ),
                              trailing: Transform.scale(
                                scale: size.width * 0.003,
                                child: Checkbox(
                                  onChanged: (value) {
                                    setState(() {
                                      if(memberList.contains(user)) {
                                        memberList.remove(user);
                                        isChecked[index] = false;
                                      } else {
                                        memberList.add(user);
                                        isChecked[index] = true;
                                      }
                                      if(memberList.isNotEmpty) {
                                        showListMember = true;
                                      } else {
                                        showListMember = false;
                                      }
                                    });
                                  },
                                  value: isChecked[index],
                                  activeColor: lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(size.width * 0.05),
                                  ),
                                  side: BorderSide(
                                      color: Colors.black38, width: size.width * 0.002),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showFriendSearchResult,
                      child: Column(
                        children: [
                          if(searchFriendController.text == "" || friendListSearch.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: size.width*0.03),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text("Không tìm thấy kết quả", style: TextStyle(fontSize: size.width*0.045),)
                            ),
                          ),
                          if(friendListSearch.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: size.width*0.05, top: size.width*0.035),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: friendListSearch.length,
                              itemBuilder: (context, index) {
                                User user = friendListSearch[index];
                                return ListTile(
                                  leading: FunctionService.createAvatar(
                                      user.avatarUrl, size, user.name!, LISTCHAT),
                                  title: Text(
                                    user.name!,
                                    style: TextStyle(fontSize: size.width * 0.04),
                                  ),
                                  trailing: Transform.scale(
                                    scale: size.width * 0.003,
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          List<String> memPhone = [];

                                          memberList.forEach((mem) {
                                            memPhone.add(mem.phone!);
                                          });

                                          var numIndex;
                                          friendList.asMap().map((i, e) {
                                            if(e.phone == user.phone) {
                                              numIndex = i;
                                            }
                                            return MapEntry(0, 0);
                                          });

                                          if(memPhone.contains(user.phone)) {
                                            memberList.removeWhere((element) => element.phone == user.phone,);
                                            isCheckedInSearch[index] = false;
                                            isChecked[numIndex] = false;
                                          } else {
                                            isChecked[numIndex] = true;
                                            memberList.add(user);
                                            isCheckedInSearch[index] = true;
                                          }


                                          if(memberList.isNotEmpty) {
                                            showListMember = true;
                                          } else {
                                            showListMember = false;
                                          }
                                        });
                                      },
                                      value: isCheckedInSearch[index],
                                      activeColor: lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(size.width * 0.05),
                                      ),
                                      side: BorderSide(
                                          color: Colors.black38, width: size.width * 0.002),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
            Positioned(
              top: size.height*0.82,
              child: Visibility(
                visible: showListMember,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    height: size.width * 0.15,
                    width: size.width,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width*0.02, top: size.width*0.02),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: memberList.length,
                              itemBuilder: (context, index) {
                                User member = memberList[index];
                                return SizedBox(
                                  width: size.width*0.13,
                                  child: Stack(
                                    children: [
                                      FunctionService.createAvatar(member.avatarUrl,
                                          size, member.name!, LISTCHAT),
                                      Positioned(
                                        top: -size.width*0.035,
                                        left: size.width*0.03,
                                        child: Transform.scale(
                                          scale: size.width*0.0008,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: lightGreen,
                                                shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isChecked[friendList.indexOf(memberList[index])] = false;
                                                    memberList.removeAt(index);
                                                    if(memberList.isEmpty) {
                                                      showListMember = false;
                                                    }
                                                  });
                                                },
                                                icon: Icon(Icons.close, size: size.width*0.08, color: Colors.white,)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                            child: CircleAvatar(
                              child: IconButton(
                                onPressed: () async {
                                  List<String> members = [];
                                  String title = "";
                                  String avatarURL = "";
                                  List<DeleteConversationUser> deleteConversationUsers = [];
                                  if(memberList.isNotEmpty && memberList.length >= 2) {
                                    for(User mem in memberList) {
                                      members.add(mem.phone!);
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Xảy ra lỗi', style: TextStyle(fontSize: size.width*0.04, fontWeight: FontWeight.bold),),
                                            content: Text('Bạn nên chọn thêm một thành viên để có thể tạo nhóm', style: TextStyle(fontSize: size.width*0.04),),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ok', style: TextStyle(fontSize: size.width*0.04),)
                                              )
                                            ],
                                          );
                                        },
                                    );
                                    return;
                                  }

                                  members.add(currentUser.phone!);

                                  if(groupNameController.text == "") {
                                    List<String> memNameList = [];
                                    for(User mem in memberList) {
                                      memNameList.add(mem.name!);
                                    }
                                    title = memNameList.join(", ");
                                  } else {
                                    title = groupNameController.text;
                                  }

                                  if(avatarGroupChat.thumbnail != null) {
                                    File? avatarFile = avatarGroupChat.file;
                                    String nameFile = avatarGroupChat.file!.path.split('/').last;

                                    Reference reference = FirebaseStorage.instance
                                        .ref().child('avatarImages/$nameFile');

                                    await reference.putFile(avatarFile!);

                                    avatarURL = await reference.getDownloadURL();
                                  }

                                  Conversation conversationRequest = Conversation(
                                    title: title,
                                    ava_conversation_url: avatarURL,
                                    members: members,
                                    creator_phone: currentUser.phone,
                                    updated_at: DateTime.now(),
                                    deleteConversationUsers: deleteConversationUsers,
                                    is_group: true,
                                  );
                                  print(conversationRequest);
                                  widget.stompManager.sendStompMessage("/app/user.createGroupChat", const JsonEncoder().convert(conversationRequest));
                                  Navigator.push(context, PageTransition(
                                      child: MainChat(stompManager: widget.stompManager, userToken:  userWithToken, friendRequests: friendRequests, friends: friendList,),
                                      type: PageTransitionType.topToBottom,
                                  ));
                                },
                                icon: Icon(Icons.arrow_forward, color: Colors.white, size: size.width*0.05,),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(lightGreen)
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
        bottomSheet:  Visibility(
            visible: _isOpenPicker,
            child: SizedBox(
              height: size.height * 0.4,
              child: MediaPicker(
                mediaList: mediaList,
                mediaType: MediaType.image,
                mediaCount: MediaCount.single,
                onPicked: (selectedList) {
                  setState(() {
                    mediaList = selectedList;
                    _isOpenPicker = false;
                    avatarGroupChat = mediaList.first;
                    imageAvatar = avatarGroupChat.thumbnail!;
                    showButtonPickImage = false;
                    showAvatar = true;
                  });
                },
                onCancel: () => {
                  setState(() {
                    _isOpenPicker = false;
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
      ),
    );
  }
}
