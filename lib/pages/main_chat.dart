import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/ConversationResponse.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/chat_list_widget.dart';
import 'package:fe_mobile_chat_app/pages/endrawer_main_chat.dart';
import 'package:fe_mobile_chat_app/pages/friend_list_widget.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/conversation_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/message_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/Conversation.dart';

class MainChat extends StatefulWidget {
  final StompManager stompManager;
  const MainChat({super.key, required this.stompManager});

  @override
  State<MainChat> createState() => _MainChatState();
}

late var _listUserOnline;
User currentUser = User();
var userToken;
List<User> friendListCurrentUser = [];
bool showFriendResults = false;

class _MainChatState extends State<MainChat> {
  var _index = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _tabBodies;

  @override
  void initState() {
    super.initState();

    widget.stompManager.subscribeToDestination("/topic/public").listen((frame) {
      List<String> values = [];
      final body = frame.body;
      values.add(body!);
      print("Subscribe value: ${values}");
    });
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == 2) {
        _scaffoldKey.currentState?.openEndDrawer();
      } else if (index == 1) {
        _tabBodies = FriendsListWidget(currentUser: currentUser!);
      } else if (index == 0) {
        _tabBodies = ChatsListWidget(currentUser: currentUser!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userToken = ModalRoute.of(context)?.settings.arguments as UserToken;
    currentUser = userToken.user;
    // print("current user: ${currentUser.toString()}");
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    _tabBodies ??= ChatsListWidget(currentUser: currentUser!);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset("assets/images/Smilechat-logo.svg"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: darkGreen,
                size: size.height * 0.03,
              ))
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
      endDrawer: MyEndrawer(currentUser: currentUser, stompManager: widget.stompManager,),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: padding.vertical * 0.5, bottom: padding.vertical * 0.1),
              child: SizedBox(
                width: size.width * 0.8,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          if (friendListCurrentUser.isNotEmpty) {
                            showFriendResults = true;
                          } else {
                            showFriendResults = false;
                          }
                        });
                      },
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: lightGreen),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: greyDark,
                          ),
                          contentPadding: EdgeInsets.all(size.height * 0.01),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.normal,
                              color: greyDark),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: lightGray),
                            borderRadius: BorderRadius.circular(size.width),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(size.width),
                              borderSide: const BorderSide(color: lightGreen))),
                    ),
                    Visibility(
                      visible: showFriendResults,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: friendListCurrentUser.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: lightGreen))),
                                  child: ListTile(
                                    title: Text(friendListCurrentUser[index]
                                        .name
                                        .toString()),
                                    leading: FunctionService.createAvatar(
                                        friendListCurrentUser[index]
                                            .avatarUrl
                                            .toString(),
                                        size,
                                        friendListCurrentUser[index]
                                            .name
                                            .toString()),
                                    trailing: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.person_add_outlined,
                                        color: lightGreen,
                                      ),
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
