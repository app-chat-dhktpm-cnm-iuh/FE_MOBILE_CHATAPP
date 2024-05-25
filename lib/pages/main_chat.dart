import 'dart:convert';


import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/chat_list_widget.dart';
import 'package:fe_mobile_chat_app/pages/create_group_chat_page.dart';
import 'package:fe_mobile_chat_app/pages/endrawer_main_chat.dart';
import 'package:fe_mobile_chat_app/pages/friend_list_widget.dart';
import 'package:fe_mobile_chat_app/pages/search_friend_page.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class MainChat extends StatefulWidget {
  final StompManager stompManager;
  final UserToken userToken;
  List<FriendRequest> friendRequests;
  List<User> friends;
  dynamic tabBodies;

  MainChat({
    super.key,
    required this.stompManager,
    required this.userToken,
    required this.friendRequests,
    required this.friends,
    this.tabBodies
  });

  @override
  State<MainChat> createState() => _MainChatState();
}

late var _listUserOnline;
User currentUser = User();
UserToken userWithToken = UserToken();
bool showFriendResults = false;

class _MainChatState extends State<MainChat> {
  var _index = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _tabBodies;
  var tabBodiesReturn;
  bool showMarkFriendRequestReceive = false;
  List<FriendRequest> friendRequestReceive = [];
  List<User> friendListCurrentUser = [];
  @override
  void initState() {
    super.initState();
    userWithToken = widget.userToken;
    currentUser = userWithToken.user!;
    friendListCurrentUser = widget.friends;
    friendRequestReceive = widget.friendRequests;
    tabBodiesReturn = widget.tabBodies;

    if(friendRequestReceive.isNotEmpty) {
      setState(() {
        showMarkFriendRequestReceive = true;
      });
    }
    widget.stompManager.subscribeToDestination("/topic/public", (frame) {
      print("subscribe topic public");
      print(frame.body);
    },);

    widget.stompManager.subscribeToDestination("/user/${currentUser.phone}/queue/friend-request", (frame) {
      setState(() {
        print("subscribe friend request");
        dynamic friendRequestDynamic = jsonDecode(frame.body!);
        FriendRequest friendRequest = FriendRequest.fromJson(friendRequestDynamic);
        friendRequestReceive.add(friendRequest);
        showMarkFriendRequestReceive = true;
      });
      print(friendRequestReceive);
    });

    widget.stompManager.subscribeToDestination("/user/${currentUser.phone}/queue/friend-reply", (frame) {
      setState(() {
        print("subscribe friend reply");
        dynamic friendRequestDynamic = jsonDecode(frame.body!);
        FriendRequest friendRequest = FriendRequest.fromJson(friendRequestDynamic);
        friendRequestReceive.remove(friendRequest);
        if(friendRequestReceive.isNotEmpty) {
          showMarkFriendRequestReceive = true;
        } else {
          showMarkFriendRequestReceive = false;
        }
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      print(index);
      if (index == 2) {
        _scaffoldKey.currentState?.openEndDrawer();
      } else if (index == 1) {
        _tabBodies = FriendsListWidget(
          userToken: userWithToken,
          friendRequests: friendRequestReceive,
          friends: friendListCurrentUser,
          stompManager: widget.stompManager,
        );
      } else if (index == 0) {
        _tabBodies = ChatsListWidget(currentUser: currentUser, stompManager: widget.stompManager,);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;

    if(tabBodiesReturn != null) {
      _tabBodies = tabBodiesReturn;
    }

    _tabBodies ??= ChatsListWidget(currentUser: currentUser, stompManager: widget.stompManager,);

    tabBodiesReturn = null;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset("assets/images/Smilechat-logo.svg"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.add, color: lightGreen, size: size.width*0.08,),
            color: lightGreen,
            itemBuilder: (context)  => [
              PopupMenuItem(
                  child: Row(
                    children: [
                      Expanded(
                          child: Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: size.width*0.065)
                      ),
                      Expanded(
                          flex: 2,
                          child: Text("Thêm bạn", style: TextStyle(fontSize: size.width*0.04, color: Colors.white))
                      ),
                    ],
                  ),
              ),
              PopupMenuItem(
                  onTap: () {
                    Navigator.push(context, PageTransition(child: CreateGroupChatPage(stompManager: widget.stompManager, userToken: userWithToken), type: PageTransitionType.fade));
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Icon(CupertinoIcons.chat_bubble_2_fill, color: Colors.white, size: size.width*0.065)
                      ),
                      Expanded(
                          flex: 2,
                          child: Text("Tạo nhóm", style: TextStyle(fontSize: size.width*0.04, color: Colors.white))
                      ),
                    ],
                  )
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: lightGreen))),
        child: BottomNavigationBar(
          currentIndex: _index,
          iconSize: padding.vertical * 0.6,
          backgroundColor: backgroundColor,
          selectedItemColor: darkGreen,
          unselectedItemColor: lightGreen,
          onTap: (value) {
            setState(() {
              _index = value;
              onTabTapped(value);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_fill, size: size.width*0.07,),
                label: "Trò chuyện"),
            BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Visibility(
                      visible: showMarkFriendRequestReceive,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: size.width*0.01),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: SizedBox(
                            width: size.width*0.015,
                            height: size.width*0.015,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.contacts_rounded, size: size.width*0.07,),
                  ],
                ), label: "Danh bạ"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_fill, size: size.width*0.07,), label: "Cá nhân"),
          ],
        ),
      ),
      endDrawer: MyEndrawer(userToken: userWithToken, stompManager: widget.stompManager, friendRequests: friendRequestReceive, friends: friendListCurrentUser,),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: padding.vertical * 0.5, bottom: padding.vertical * 0.1),
              child: SizedBox(
                width: size.width * 0.8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        PageTransition(
                            child: SearchFriendPage(stompManager: widget.stompManager, userToken: userWithToken, friendRequests: friendRequestReceive, friends: friendListCurrentUser,),
                            type: PageTransitionType.bottomToTop)
                    );
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: lightGreen),
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
                          borderSide: BorderSide(color: Colors.black12, width: size.width*0.0035),
                          borderRadius: BorderRadius.circular(size.width),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _tabBodies
          ],
        ),
      ),
    );
  }
}
