import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/friend_tab.dart';
import 'package:fe_mobile_chat_app/pages/group_tab.dart';
import 'package:flutter/material.dart';

class FriendsListWidget extends StatefulWidget {
  User currentUser;
  FriendsListWidget({
    super.key,
    required this.currentUser
  });

  @override
  State<FriendsListWidget> createState() => _FriendsListWidgetState();
}

class _FriendsListWidgetState extends State<FriendsListWidget> {
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
                  children: [FriendsTab(currentUser: widget.currentUser), GroupTab(currentUser: widget.currentUser)],
                ))
          ],
        ),
      ),
    );
  }
}
