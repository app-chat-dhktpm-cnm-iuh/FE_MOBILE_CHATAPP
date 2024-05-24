import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/chat_list_widget.dart';
import 'package:fe_mobile_chat_app/pages/create_group_chat_page.dart';
import 'package:fe_mobile_chat_app/pages/endrawer_main_chat.dart';
import 'package:fe_mobile_chat_app/pages/friend_list_widget.dart';
import 'package:fe_mobile_chat_app/pages/search_friend_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/conversation_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/message_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import '../model/Conversation.dart';

class MainChat extends StatefulWidget {
  final StompManager stompManager;
  MainChat({super.key, required this.stompManager});

  @override
  State<MainChat> createState() => _MainChatState();
}

late var _listUserOnline;
User currentUser = User();
var userToken;
bool showFriendResults = false;

class _MainChatState extends State<MainChat> {
  var _index = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _tabBodies;

  @override
  void initState() {
    super.initState();
    widget.stompManager.subscribeToDestination("/topic/public", (frame) {
      print("subscribe topic public");
      print(frame.body);
    },);
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == 2) {
        _scaffoldKey.currentState?.openEndDrawer();
      } else if (index == 1) {
        _tabBodies = FriendsListWidget(currentUser: currentUser);
      } else if (index == 0) {
        _tabBodies = ChatsListWidget(currentUser: currentUser, stompManager: widget.stompManager,);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userToken = ModalRoute.of(context)?.settings.arguments as UserToken;

    currentUser = userToken.user;
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    _tabBodies ??= ChatsListWidget(currentUser: currentUser, stompManager: widget.stompManager,);

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
                    Navigator.push(context, PageTransition(child: CreateGroupChatPage(stompManager: widget.stompManager, userToken: userToken), type: PageTransitionType.fade));
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
          items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_fill),
                label: "Trò chuyện"),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts_rounded), label: "Danh bạ"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_fill), label: "Cá nhân"),
          ],
        ),
      ),
      endDrawer: MyEndrawer(userToken: userToken, stompManager: widget.stompManager,),
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
                            child: SearchFriendPage(stompManager: widget.stompManager, user: currentUser,),
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
