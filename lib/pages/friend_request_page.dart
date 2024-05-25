import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Friend.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/friend_list_widget.dart';
import 'package:fe_mobile_chat_app/pages/friend_tab.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/user_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FriendRequestPage extends StatefulWidget {
  final UserToken userToken;
  final List<User> sentFriendRequests;
  final List<User> receivedFriendRequests;
  final List<User> friends;
  final List<FriendRequest> friendRequests;
  final StompManager stompManager;
  const FriendRequestPage({
    super.key,
    required this.userToken,
    required this.sentFriendRequests,
    required this.receivedFriendRequests,
    required this.friends,
    required this.friendRequests,
    required this.stompManager
  });

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  UserToken userWithToken = UserToken();
  StompManager stompManager = StompManager();
  List<User> friendList = [];
  List<User> sentFriendRequestList = [];
  List<User> receivedFriendRequestList = [];
  List<FriendRequest> friendRequestList = [];
  bool showSendFriendRequestInSentRequestList = false;
  bool showCancleFriendRequestInSentRequestList = true;

  bool showSendFriendRequestInReceivedRequestList = false;
  bool showCancleFriendRequestInReceivedRequestList = false;
  bool showAcceptFriendRequestInReceivedRequestList = true;
  @override
  void initState() {
    super.initState();
    userWithToken = widget.userToken;
    friendList = widget.friends;
    friendRequestList = widget.friendRequests;
    stompManager = widget.stompManager;
    sentFriendRequestList = widget.sentFriendRequests;
    receivedFriendRequestList = widget.receivedFriendRequests;
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,),
          onPressed: () {
            dynamic tabBodies = FriendsListWidget(
              userToken: userWithToken,
              friendRequests: friendRequestList,
              friends: friendList,
              stompManager: widget.stompManager,
            );

            Navigator.push(context, PageTransition(
                child: MainChat(
                  userToken: userWithToken,
                  friendRequests: friendRequestList,
                  friends: friendList,
                  stompManager: stompManager,
                  tabBodies: tabBodies,
                ),
                type: PageTransitionType.leftToRight
            ));
          },
        ),
        title: Text("Danh sách lời mời kết bạn", style: TextStyle(fontSize: size.width*0.04, color: Colors.white),),
        backgroundColor: lightGreen,
        leadingWidth: size.width*0.07,
        toolbarHeight: size.height*0.06,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02, top: size.width*0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02, bottom: size.width*0.02),
              child: Text("Đã gửi ${sentFriendRequestList.length}", style: TextStyle(fontSize: size.width*0.04, fontWeight: FontWeight.bold),),
            ),
            if(sentFriendRequestList.isNotEmpty)
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sentFriendRequestList.length,
                itemBuilder: (context, index) {
                  User receiver = sentFriendRequestList[index];
                  var ava_url = receiver.avatarUrl;
                  var receiverName = receiver.name;
                  var receiverPhone = receiver.phone;
                  print(receiver);
                  return ListTile(
                    leading: FunctionService.createAvatar(ava_url, size, receiverName!, LISTCHAT),
                    title: Text(receiverName, style: TextStyle(fontSize: size.width*0.04),),
                    trailing: Stack(
                      children: [
                        Visibility(
                          visible: showSendFriendRequestInSentRequestList,
                          child: IconButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Colors.black12)
                            ),
                            onPressed: () {
                              setState(() {
                                FriendRequest friendRequest = FriendRequest(
                                    sender_phone: userWithToken.user?.phone,
                                    aceppted: false,
                                    receiver_phone: receiverPhone
                                );
                                stompManager.sendStompMessage("/app/user.addFriend", JsonEncoder().convert(friendRequest.toJson()));
                                showSendFriendRequestInSentRequestList = false;
                                showCancleFriendRequestInSentRequestList = true;
                              });
                            },
                            icon: Icon(Icons.person_add_alt_1, size: size.width*0.06, color: darkGreen,),
                          ),
                        ),
                        Visibility(
                            visible: showCancleFriendRequestInSentRequestList,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  String? friendRequestId = "";
                                  for (var friendRequest in friendRequestList) {
                                    if(friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == receiverPhone) {
                                      setState(() {
                                        friendRequestId = friendRequest.id;
                                      });
                                    }
                                  }

                                  FriendRequest friendRequest = FriendRequest(
                                      id: friendRequestId,
                                      sender_phone: userWithToken.user?.phone,
                                      aceppted: false,
                                      receiver_phone: receiverPhone
                                  );

                                  stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));
                                  showCancleFriendRequestInSentRequestList = false;
                                  showSendFriendRequestInSentRequestList = true;
                                  setState(() {
                                    friendRequestList.removeWhere((friendRequest) => friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == receiverPhone,);
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
                            )),
                      ],
                    ),
                  );
                },
            ),

            Padding(
              padding: EdgeInsets.all(size.width*0.02),
              child: Text("Đã nhận ${receivedFriendRequestList.length}", style: TextStyle(fontSize: size.width*0.04, fontWeight: FontWeight.bold),),
            ),
            if(receivedFriendRequestList.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: receivedFriendRequestList.length,
              itemBuilder: (context, index) {
                User sender = receivedFriendRequestList[index];
                var senderName = sender.name!;
                var ava_sender = sender.avatarUrl;
                var senderPhone = sender.phone;

                return ListTile(
                  leading: FunctionService.createAvatar(ava_sender, size, senderName, LISTCHAT),
                  title: Text(senderName, style: TextStyle(fontSize: size.width*0.04),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showSendFriendRequestInReceivedRequestList,
                        child: IconButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.black12)
                          ),
                          onPressed: () {
                            setState(() {
                              FriendRequest friendRequest = FriendRequest(
                                  sender_phone: userWithToken.user?.phone,
                                  aceppted: false,
                                  receiver_phone: senderPhone
                              );
                              stompManager.sendStompMessage("/app/user.addFriend", JsonEncoder().convert(friendRequest.toJson()));
                              friendRequestList.add(friendRequest);
                              showSendFriendRequestInReceivedRequestList = false;
                              showCancleFriendRequestInReceivedRequestList = true;
                            });
                          },
                          icon: Icon(Icons.person_add_alt_1, size: size.width*0.06, color: darkGreen,),
                        ),
                      ),
                      Visibility(
                          visible: showCancleFriendRequestInReceivedRequestList,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                String? friendRequestId = "";
                                for (var friendRequest in friendRequestList) {
                                  if(friendRequest.sender_phone == senderPhone && friendRequest.receiver_phone == userWithToken.user?.phone) {
                                    setState(() {
                                      friendRequestId = friendRequest.id;
                                    });
                                  }
                                }

                                FriendRequest friendRequest = FriendRequest(
                                    id: friendRequestId,
                                    sender_phone: senderPhone,
                                    aceppted: false,
                                    receiver_phone: userWithToken.user?.phone
                                );

                                stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));
                                showCancleFriendRequestInSentRequestList = false;
                                showSendFriendRequestInSentRequestList = true;
                                setState(() {
                                  friendRequestList.removeWhere((friendRequest) => friendRequest.sender_phone == senderPhone && friendRequest.receiver_phone == userWithToken.user?.phone,);
                                });

                                showCancleFriendRequestInReceivedRequestList = false;
                                showSendFriendRequestInReceivedRequestList = true;
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
                          )),
                      Visibility(
                          visible: showAcceptFriendRequestInReceivedRequestList,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    String? friendRequestId = "";
                                    for (var friendRequest in friendRequestList) {
                                      if((friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == senderPhone)
                                          || (friendRequest.sender_phone == senderPhone && friendRequest.receiver_phone == userWithToken.user?.phone) ) {
                                        setState(() {
                                          friendRequestId = friendRequest.id;
                                        });
                                      }
                                    }

                                    print(friendRequestId);

                                    FriendRequest friendRequest = FriendRequest(
                                        id: friendRequestId,
                                        sender_phone: senderPhone,
                                        aceppted: true,
                                        receiver_phone: userWithToken.user?.phone
                                    );

                                    print(friendRequest);

                                    stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));
                                    setState(() {
                                      friendRequestList.removeWhere((friendRequest) => (friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == senderPhone)
                                          || (friendRequest.sender_phone == senderPhone && friendRequest.receiver_phone == userWithToken.user?.phone) );
                                      friendList.add(sender);
                                    });

                                    showAcceptFriendRequestInReceivedRequestList = false;
                                    showCancleFriendRequestInReceivedRequestList = false;
                                    showSendFriendRequestInReceivedRequestList = false;
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
                              ),
                              SizedBox(
                                  width: size.width*0.02,
                                  child: const Spacer()
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    String? friendRequestId = "";
                                    for (var friendRequest in friendRequestList) {
                                      if((friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == senderPhone)
                                          || (friendRequest.sender_phone == senderPhone && friendRequest.receiver_phone == userWithToken.user?.phone) ) {
                                        setState(() {
                                          friendRequestId = friendRequest.id;
                                        });
                                      }
                                    }

                                    FriendRequest friendRequest = FriendRequest(
                                        id: friendRequestId,
                                        sender_phone: senderPhone,
                                        aceppted: false,
                                        receiver_phone: userWithToken.user?.phone
                                    );

                                    stompManager.sendStompMessage("/app/user.replyFriendRequest", JsonEncoder().convert(friendRequest.toJson()));
                                    setState(() {
                                      friendRequestList.removeWhere((friendRequest) => (friendRequest.sender_phone == userWithToken.user?.phone && friendRequest.receiver_phone == senderPhone)
                                          || (friendRequest.sender_phone == senderPhone && friendRequest.receiver_phone == userWithToken.user?.phone) ,);
                                    });

                                    showAcceptFriendRequestInReceivedRequestList = false;
                                    showCancleFriendRequestInReceivedRequestList = false;
                                    showSendFriendRequestInReceivedRequestList = true;
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
                              ),
                            ],
                          ))
                    ],
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
