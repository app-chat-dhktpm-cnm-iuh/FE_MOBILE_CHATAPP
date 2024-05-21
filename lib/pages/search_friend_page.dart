import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SearchFriendPage extends StatefulWidget {
  final StompManager stompManager;
  final User user;
  const SearchFriendPage({super.key, required this.stompManager, required this.user});

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {

  @override
  void initState() {
    super.initState();
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
            Navigator.pop(context, PageTransition(child: MainChat(stompManager: widget.stompManager,), type: PageTransitionType.leftToRight));
          },
        ),
        title: TextField(
          style: TextStyle(
              fontSize: size.height * 0.02,
              fontWeight: FontWeight.bold,
              color: lightGreen),
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
      ),
    );
  }


}
