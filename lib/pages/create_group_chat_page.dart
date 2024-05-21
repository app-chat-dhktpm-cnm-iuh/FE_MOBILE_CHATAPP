import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CreateGroupChatPage extends StatefulWidget {
  final StompManager stompManager;
  final UserToken userToken;
  const CreateGroupChatPage({super.key, required this.stompManager, required this.userToken});

  @override
  State<CreateGroupChatPage> createState() => _CreateGroupChatPageState();
}


class _CreateGroupChatPageState extends State<CreateGroupChatPage> {
  UserToken userWithToken = UserToken();
  @override
  void initState() {
    super.initState();
    userWithToken = widget.userToken;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: lightGreen,
          leadingWidth: size.width*0.08,
          leading: IconButton(onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width*0.02)
                  ),
                  title: Text("Lưu ý", style: TextStyle(fontSize: size.width*0.04, fontWeight: FontWeight.bold)),
                  // titlePadding: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: size.width*0.02),
                  content: Text("Bạn có chắc chắn thoát ?", style: TextStyle(fontSize: size.width*0.04),),
                  contentPadding: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: size.width*0.02),
                  backgroundColor: backgroundColor,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => false);
                        Navigator.push(context, PageTransition(
                            child: MainChat(stompManager: widget.stompManager,),
                            type: PageTransitionType.fade,
                            settings: RouteSettings(
                              arguments: userWithToken
                            )
                        ));
                      },
                      child: Text("Thoát", style: TextStyle(color: Colors.redAccent, fontSize: size.width*0.04),),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ở lại",style: TextStyle(color: lightGreen, fontSize: size.width*0.04),)
                    )
                  ],
                ),
            );
          },
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: size.width*0.05,)),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text("Tạo nhóm chat mới", style: TextStyle(color: Colors.white, fontSize: size.width*0.04, fontWeight: FontWeight.bold)),
                Text("Đã chọn 1 thành viên", style: TextStyle(color: Colors.white, fontSize: size.width*0.035))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(size.width*0.02),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: IconButton(onPressed: () {

                      }, icon: Icon(Icons.camera_alt_rounded, color: lightGreen, size: size.width*0.1,))
                  ),
                  Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Đặt tên nhóm",
                          hintStyle: TextStyle(
                            fontSize: size.width*0.045,
                            color: Colors.black38,
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none
                            )
                          )
                        ),
                      )
                  )
                ],
              ),
              Container(
                width: size.width*0.8,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
