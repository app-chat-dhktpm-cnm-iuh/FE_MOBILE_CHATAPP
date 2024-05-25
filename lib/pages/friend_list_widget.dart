import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/friend_tab.dart';
import 'package:fe_mobile_chat_app/pages/group_tab.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/material.dart';

class FriendsListWidget extends StatefulWidget {
  final UserToken userToken;
  final List<FriendRequest> friendRequests;
  final List<User> friends;
  final StompManager stompManager;
  FriendsListWidget({
    super.key,
    required this.userToken,
    required this.friendRequests,
    required this.friends,
    required this.stompManager
  });

  @override
  State<FriendsListWidget> createState() => _FriendsListWidgetState();
}



class _FriendsListWidgetState extends State<FriendsListWidget> {
  UserToken userWithToken = UserToken();
  List<FriendRequest> friendRequestList = [];
  List<User> friendLists = [];
  StompManager stompManager = StompManager();

  @override
  void initState() {
      super.initState();
      userWithToken = widget.userToken;
      friendRequestList = widget.friendRequests;
      friendLists = widget.friends;
      stompManager = widget.stompManager;
      print(friendLists);
  }

  @override
  void dispose() {
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: lightGreen))),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: darkGreen,
                labelStyle: TextStyle(
                    color: lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.04),
                unselectedLabelStyle: TextStyle(
                    color: lightGreen,
                    fontWeight: FontWeight.normal,
                    fontSize: size.width * 0.04),
                tabs: const [
                  Tab(
                    text: 'Bạn bè',
                  ),
                  Tab(
                    text: 'Nhóm',
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
                children: [
                  FriendsTab(
                    friends: friendLists,
                    userToken: userWithToken,
                    friendRequests: friendRequestList,
                    stompManager: stompManager,
                  ),
                  GroupTab(currentUser: userWithToken.user!)],
                ))
          ],
        ),
      ),
    );
  }
}
