import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/search_friend_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class PersonalWallPage extends StatefulWidget {
  final StompManager stompManager;
  final UserToken userToken;
  final User searchUser;
  final List<FriendRequest> friendRequests;
  final List<User> friendList;
  const PersonalWallPage({
    super.key,
    required this.stompManager,
    required this.userToken,
    required this.searchUser,
    required this.friendRequests,
    required this.friendList
  });

  @override
  State<PersonalWallPage> createState() => _PersonalWallPageState();
}

class _PersonalWallPageState extends State<PersonalWallPage> {
  StompManager stompManager = StompManager();
  UserToken userWithToken = UserToken();
  User searchUserDetail = User();
  bool showSendFriendRequest = true;
  bool showCancleFriendRequest = false;
  bool showReplyFriendRequest = false;
  bool showDeclineFriendRequest = false;
  bool addSpacer = true;
  List<User> friends = [];
  List<FriendRequest> friendRequestList = [];

  @override
  void initState() {
    super.initState();
      stompManager = widget.stompManager;
      userWithToken = widget.userToken;
      searchUserDetail = widget.searchUser;
      friends = widget.friendList;
      friendRequestList = widget.friendRequests;

      print(friendRequestList);
      checkIsFriendOrFriendRequestContain();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkIsFriendOrFriendRequestContain()  {
    var currentPhone = userWithToken.user?.phone;
    var friendPhone = searchUserDetail.phone;

    for (var friendRequest in friendRequestList) {
      if((friendRequest.sender_phone == currentPhone || friendRequest.receiver_phone == currentPhone )
          && (friendRequest.sender_phone == friendPhone || friendRequest.receiver_phone == friendPhone)) {
        setState(() {
          if(friendRequest.sender_phone == currentPhone) {
            showSendFriendRequest = false;
            showCancleFriendRequest = true;
          } else {
            showReplyFriendRequest = true;
            showDeclineFriendRequest = true;
            showSendFriendRequest = false;
          }
        });
      }
    }

    for(var friend in friends) {
      if(friendPhone == friend.phone) {
        setState(() {
          showSendFriendRequest = false;
          addSpacer = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height*0.3,
                width: size.width,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () { },
                      child: Image.asset(
                        'assets/images/wallpager-default.jpg',
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: size.height*0.05,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(context, PageTransition(
                                child: SearchFriendPage(stompManager: stompManager, userToken: userWithToken, friendRequests: friendRequestList, friends: friends,),
                                type:PageTransitionType.fade,
                                settings: RouteSettings(arguments: userWithToken)
                            ));
                          },
                          icon: Icon(Icons.arrow_back_rounded, color: darkGreen,size: size.width*0.06,)
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height*0.04, left: size.height*0.02, right: size.height*0.02),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(searchUserDetail.name!, style: TextStyle(
                            fontSize: size.width*0.05
                        ),)
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:  size.height*0.02, bottom: size.height*0.02),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigator.push(context, PageTransition(child: UpdateUserDetailsPage(stompManager: stompManager, userToken: userWithToken, ), type: PageTransitionType.bottomToTop));
                                  },
                                  style: ButtonStyle(
                                      alignment: Alignment.center,
                                      backgroundColor: MaterialStateProperty.all(darkGreen),
                                      fixedSize: MaterialStateProperty.all(
                                          Size(size.width, size.height*0.05)
                                      )
                                  ),
                                  icon: Icon(CupertinoIcons.chat_bubble_text, color: Colors.white, size: size.width*0.05,),
                                  label: Text("Nhắn tin", style: TextStyle(
                                      fontSize: size.width*0.04,
                                      color: Colors.white
                                  ),)
                              )
                          ),
                          Visibility(
                            visible: addSpacer,
                            child: SizedBox(
                                width: size.width*0.04,
                                child: const Spacer()
                            ),
                          ),
                          Visibility(
                            visible: showSendFriendRequest,
                            child: Expanded(
                                child: IconButton(
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.black12)
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      FriendRequest friendRequest = FriendRequest(
                                          sender_phone: userWithToken.user?.phone,
                                          aceppted: false,
                                          receiver_phone: searchUserDetail.phone
                                      );
                                      stompManager.sendStompMessage("/app/user.addFriend", JsonEncoder().convert(friendRequest.toJson()));
                                      showSendFriendRequest = false;
                                      showCancleFriendRequest = true;
                                    });
                                  },
                                  icon: Icon(Icons.person_add_alt_1, size: size.width*0.06, color: darkGreen,),
                                )
                            ),
                          ),
                          Visibility(
                              visible: showCancleFriendRequest,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    String? friendRequestId = "";

                                    for (var friendRequest in friendRequestList) {
                                      if((friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == searchUserDetail.phone)
                                      || (friendRequest.sender_phone == searchUserDetail.phone && friendRequest.receiver_phone == userWithToken.user?.phone)) {
                                        setState(() {
                                          friendRequestId = friendRequest.id;
                                        });
                                      }
                                    }

                                    FriendRequest friendRequest = FriendRequest(
                                        id: friendRequestId,
                                        sender_phone: userWithToken.user?.phone,
                                        aceppted: false,
                                        receiver_phone: searchUserDetail.phone
                                    );

                                    stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));

                                    showCancleFriendRequest = false;
                                    showSendFriendRequest = true;
                                    setState(() {
                                      friendRequestList.removeWhere((friendRequest) => (friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == searchUserDetail.phone)
                                          || (friendRequest.sender_phone == searchUserDetail.phone && friendRequest.receiver_phone == userWithToken.user?.phone),);
                                    });
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: const MaterialStatePropertyAll(Colors.black12),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(size.width),
                                      side: BorderSide(color: lightGreen, width: size.width*0.005)
                                    )
                                  )
                                ),
                                child: Text("Hủy kết bạn", style: TextStyle(fontSize: size.width*0.04, color: lightGreen),),
                              )
                          ),
                          Visibility(
                              visible: showReplyFriendRequest,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    String? friendRequestId = "";
                                    for (var friendRequest in friendRequestList) {
                                      if((friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == searchUserDetail.phone)
                                          || (friendRequest.sender_phone == searchUserDetail.phone && friendRequest.receiver_phone == userWithToken.user?.phone) ) {
                                        setState(() {
                                          friendRequestId = friendRequest.id;
                                        });
                                      }
                                    }

                                    FriendRequest friendRequest = FriendRequest(
                                        id: friendRequestId,
                                        sender_phone: searchUserDetail.phone,
                                        aceppted: true,
                                        receiver_phone: userWithToken.user?.phone
                                    );

                                    stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));
                                    setState(() {
                                      friendRequestList.removeWhere((friendRequest) => (friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == searchUserDetail.phone)
                                          || (friendRequest.sender_phone == searchUserDetail.phone && friendRequest.receiver_phone == userWithToken.user?.phone),);
                                    });
                                    showCancleFriendRequest = false;
                                    showSendFriendRequest = false;
                                    showDeclineFriendRequest = false;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor: const MaterialStatePropertyAll(Colors.black12),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(size.width),
                                            side: BorderSide(color: lightGreen, width: size.width*0.005)
                                        )
                                    )
                                ),
                                child: Text("Chấp nhận", style: TextStyle(fontSize: size.width*0.04, color: lightGreen),),
                              )
                          ),
                          Visibility(
                              visible: showDeclineFriendRequest,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    String? friendRequestId = "";
                                    for (var friendRequest in friendRequestList) {
                                      if((friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == searchUserDetail.phone)
                                          || (friendRequest.sender_phone == searchUserDetail.phone && friendRequest.receiver_phone == userWithToken.user?.phone) ) {
                                        setState(() {
                                          friendRequestId = friendRequest.id;
                                        });
                                      }
                                    }

                                    FriendRequest friendRequest = FriendRequest(
                                        id: friendRequestId,
                                        sender_phone: searchUserDetail.phone,
                                        aceppted: false,
                                        receiver_phone: userWithToken.user?.phone
                                    );

                                    stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));
                                    setState(() {
                                      friendRequestList.removeWhere((friendRequest) => (friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == searchUserDetail.phone)
                                          || (friendRequest.sender_phone == searchUserDetail.phone && friendRequest.receiver_phone == userWithToken.user?.phone),);
                                    });
                                    showCancleFriendRequest = false;
                                    showSendFriendRequest = true;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor: const MaterialStatePropertyAll(Colors.black12),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(size.width),
                                            side: BorderSide(color: Colors.redAccent, width: size.width*0.005)
                                        )
                                    )
                                ),
                                child: Text("Từ chối", style: TextStyle(fontSize: size.width*0.04, color: Colors.redAccent),),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: size.height*0.2,
            left: size.width*0.35,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width*0.02),
                  child: FunctionService.createAvatar(searchUserDetail.avatarUrl, size, searchUserDetail.name!, PERSONAL_WALL),
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}
