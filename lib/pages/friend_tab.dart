import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/friend_request_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/user_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class FriendsTab extends StatefulWidget {
  final UserToken userToken;
  final List<FriendRequest> friendRequests;
  final List<User> friends;
  final StompManager stompManager;
  FriendsTab({
    super.key,
    required this.userToken,
    required this.friendRequests,
    required this.friends,
    required this.stompManager
  });

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<User> friendListCurrentUser = [];
  List<FriendRequest> friendRequestLists = [];
  User currentUser = User();
  UserToken userWithToken = UserToken();
  bool showMarkFriendRequest = false;
  StompManager stompManager = StompManager();
  @override
  void initState() {
    super.initState();
    friendListCurrentUser = widget.friends;
    currentUser = widget.userToken.user!;
    userWithToken = widget.userToken;
    friendRequestLists = widget.friendRequests;
    stompManager = widget.stompManager;
    if(friendRequestLists.isNotEmpty) {
      setState(() {
        showMarkFriendRequest = true;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        TextButton(
          onPressed: () async {
            List<User> sentFriendRequestLists = [];
            List<User> receivedFriendRequestLists = [];

            try {
              for (var friendRequest in friendRequestLists) {
                if(friendRequest.sender_phone == currentUser.phone) {
                  await UserServiceImpl.getUserDetailByPhone(friendRequest.receiver_phone).then((value) => {
                    setState(() {
                      sentFriendRequestLists.add(value);
                    })
                  });
                } else {
                  await UserServiceImpl.getUserDetailByPhone(friendRequest.sender_phone).then((value) => {
                    setState(() {
                      receivedFriendRequestLists.add(value);
                    })
                  });
                }
              }
            } catch (e) {
              print(e);
            }

            Navigator.push(context, PageTransition(
                child: FriendRequestPage(
                  friendRequests: friendRequestLists,
                  sentFriendRequests: sentFriendRequestLists,
                  receivedFriendRequests: receivedFriendRequestLists,
                  friends: friendListCurrentUser,
                  userToken: userWithToken,
                  stompManager: stompManager,),
                type: PageTransitionType.rightToLeft)
            );
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.02,
                    top: size.width * 0.03,
                    bottom: size.width * 0.03,
                    left: size.width * 0.03),
                child: SvgPicture.asset("assets/images/invites.svg"),
              ),
              Text(
                "Lời mời kết bạn",
                style:
                TextStyle(fontSize: size.width * 0.04, color: Colors.black),
              ),
              Visibility(
                visible: showMarkFriendRequest,
                child: Padding(
                  padding: EdgeInsets.only(left: size.width*0.04),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: size.width*0.025,
                    child: Text("${friendRequestLists.length}", style: TextStyle(color: Colors.white, fontSize: size.width*0.03),),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: friendListCurrentUser.length,
                  itemBuilder: (context, index) {
                    final friend = friendListCurrentUser[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.width * 0.03),
                      child: ListTile(
                        leading: FunctionService.createAvatar(
                            friend.avatarUrl?.toString(),
                            size,
                            friend.name.toString(),
                            LISTCHAT
                        ),
                        title: Text(
                          friend.name.toString(),
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}