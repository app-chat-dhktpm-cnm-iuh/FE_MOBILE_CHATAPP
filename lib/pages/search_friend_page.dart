import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/pages/personal_wall_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/user_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SearchFriendPage extends StatefulWidget {
  final StompManager stompManager;
  final UserToken userToken;
  final List<User> friends;
  final List<FriendRequest> friendRequests;
  const SearchFriendPage({
    super.key,
    required this.stompManager,
    required this.userToken,
    required this.friends,
    required this.friendRequests
  });

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  bool showFriendList = true;
  List<User> friendList = [];
  List<User> friendListSearch = [];
  List<FriendRequest> friendRequestList = [];
  User currentUser = User();
  UserToken userWithToken = UserToken();
  StompManager stompManager = StompManager();

  bool showFriendSearchResult = false;
  TextEditingController searchFriendController = TextEditingController();
  
  
  @override
  void initState() {
    super.initState();
    userWithToken = widget.userToken;
    currentUser = userWithToken.user!;
    stompManager = widget.stompManager;
    friendList = widget.friends;
    friendRequestList = widget.friendRequests;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,),
          onPressed: () {
            Navigator.push(context, PageTransition(child: MainChat(stompManager: widget.stompManager, userToken: userWithToken, friendRequests: friendRequestList, friends: friendList,), type: PageTransitionType.leftToRight));
          },
        ),
        title: TextField(
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
                await UserServiceImpl.getUserDetailByPhone(searchValue).then((user) {
                  User friend = user;
                  listFriendResult.add(friend);
                }).catchError((error) {
                  listFriendResult = [];
                });
              }
            }
            setState(() {
              if(searchFriendController.text.isNotEmpty) {
                friendListSearch = listFriendResult;
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
          ),
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black26,
              ),
              contentPadding: EdgeInsets.all(size.height*0.005),
              fillColor: Colors.white,
              filled: true,
              hintText: "Tìm kiếm",
              hintStyle: TextStyle(
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.normal,
                  color: Colors.black26),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(style: BorderStyle.none ),
                borderRadius: BorderRadius.circular(size.width),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width),
                  borderSide: BorderSide(color: lightGreen, width: size.width*0.0035))),
        ),
        backgroundColor: lightGreen,
        leadingWidth: size.width*0.07,
        toolbarHeight: size.height*0.08,
      ),
      body: Column(
        children: [
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
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.width*0.02),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: PersonalWallPage(
                                    stompManager: stompManager,
                                    userToken: userWithToken,
                                    searchUser: user,
                                    friendList: friendList,
                                    friendRequests: friendRequestList,
                                  ),
                                  type: PageTransitionType.rightToLeft)
                          );
                        },
                        leading: FunctionService.createAvatar(
                            user.avatarUrl, size, user.name!, LISTCHAT),
                        title: Text(
                          user.name!,
                          style: TextStyle(fontSize: size.width * 0.04),
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: PersonalWallPage(
                                        stompManager: stompManager,
                                        userToken: userWithToken,
                                        searchUser: user,
                                        friendList: friendList,
                                        friendRequests: friendRequestList,
                                      ),
                                      type: PageTransitionType.rightToLeft)
                              );
                            },
                            leading: FunctionService.createAvatar(
                                user.avatarUrl, size, user.name!, LISTCHAT),
                            title: Text(
                              user.name!,
                              style: TextStyle(fontSize: size.width * 0.04),
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
    );
  }


}
