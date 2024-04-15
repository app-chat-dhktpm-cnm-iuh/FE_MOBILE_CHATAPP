import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyEndrawer extends StatefulWidget {
  final User currentUser;
  final StompManager stompManager;
  MyEndrawer({super.key, required this.currentUser, required this.stompManager});

  @override
  State<MyEndrawer> createState() => _MyEndrawerState();
}

class _MyEndrawerState extends State<MyEndrawer> {
  User currentUser = User();
  late String avaUrl;
  late String name;
  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    avaUrl = widget.currentUser.avatarUrl.toString();
    name = widget.currentUser.name.toString();
  }

  @override
  Widget build(BuildContext context) {
    print(currentUser.toString());
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
          color: backgroundColor,
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: size.width * 0.2, bottom: size.width * 0.02),
                    child: FunctionService.createAvatar(avaUrl, size, name)),
                Text(
                  widget.currentUser.name.toString(),
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.width * 0.05, bottom: size.width * 0.03),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(darkGreen),
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * 0.55, size.height * 0.05))),
                    child: Text(
                      "Hồ sơ cá nhân",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.015),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, PageTransition(child: HomePage(stompManager: widget.stompManager,), type: PageTransitionType.leftToRight));
                    widget.stompManager.disconnectFromStomp();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreen),
                      fixedSize: MaterialStateProperty.all(
                          Size(size.width * 0.55, size.height * 0.05))),
                  child: Text("Đăng xuất",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.015)),
                )
              ],
            ),
          )),
    );
  }
}
