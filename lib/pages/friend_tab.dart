import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendsTab extends StatefulWidget {
  User currentUser;
  FriendsTab({super.key, required this.currentUser});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<User> friendListCurrentUser = [];
  @override
  void initState() {
    super.initState();
    friendListCurrentUser = [];
    FriendServiceImpl.getFriendListOfCurrentUser(widget.currentUser.phone).then((friends) => {
      setState(() {
        friendListCurrentUser = friends;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        TextButton(
          onPressed: () {},
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
                            friend.name.toString()),
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