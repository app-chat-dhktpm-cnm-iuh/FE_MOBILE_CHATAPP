import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/endrawer_main_chat.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/pages/update_user_details_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class UserDetailsPage extends StatefulWidget {
  final UserToken userToken;
  final StompManager stompManager;
  const UserDetailsPage({super.key, required this.userToken, required this.stompManager});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  User currentUser = User();
  UserToken userWithToken = UserToken();
  StompManager stompManager = StompManager();
  dynamic updateUser;

  @override
  void initState() {
    super.initState();
    userWithToken = widget.userToken;
    currentUser = userWithToken.user!;
    stompManager = widget.stompManager;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    String dateOfBirth = "";

    if(currentUser.dateOfBirth.toString() == 'null' || currentUser.dateOfBirth.toString() == '') {
      dateOfBirth = '20/10/2000';
    } else {
      dateOfBirth = '${currentUser.dateOfBirth?.day}/${currentUser.dateOfBirth?.month}/${currentUser.dateOfBirth?.year}';
    }

    String gender = currentUser.gender == true ? "Nam" : "Nữ";

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height*0.25,
            width: size.width,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () { },
                  child: Image.asset(
                    'assets/images/wallpager-default.jpg',
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: size.height*0.05,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(context, PageTransition(
                            child: MainChat(stompManager: stompManager,),
                            type:PageTransitionType.fade,
                            settings: RouteSettings(arguments: userWithToken)
                        ));
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: darkGreen,size: size.width*0.06,)
                  ),
                ),
                Positioned(
                  top: size.height*0.15,
                  left: size.width*0.02,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.width*0.02),
                        child: FunctionService.createAvatar(currentUser.avatarUrl, size, currentUser.name!, USERDETAIL),
                      ),
                      Text(currentUser.name!, style: TextStyle(
                        fontSize: size.width*0.05
                      ),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.height*0.02),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Thông tin cá nhân", style: TextStyle(
                    fontSize: size.width*0.04,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: lightGreen
                      )
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top:  size.height*0.02, bottom: size.height*0.02),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text("Giới tính", style: TextStyle(
                              fontSize: size.width*0.04,
                            ),)
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(gender, style: TextStyle(
                              fontSize: size.width*0.04
                            ),)
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: lightGreen
                      )
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top:  size.height*0.02, bottom: size.height*0.02),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text("Ngày sinh", style: TextStyle(
                              fontSize: size.width*0.04
                            ),)
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(dateOfBirth, style: TextStyle(
                              fontSize: size.width*0.04
                            ),)
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:  size.height*0.02, bottom: size.height*0.04),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text("Điện thoại", style: TextStyle(
                            fontSize: size.width*0.04
                          ),)
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(currentUser.phone.toString(), style: TextStyle(
                            fontSize: size.width*0.04
                          ),)
                      )
                    ],
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, PageTransition(child: UpdateUserDetailsPage(stompManager: stompManager, userToken: userWithToken, ), type: PageTransitionType.bottomToTop));
                    },
                    style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor: MaterialStateProperty.all(darkGreen),
                        fixedSize: MaterialStateProperty.all(
                          Size(size.width, size.height*0.05)
                        )
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white,),
                    label: Text("Chỉnh sửa", style: TextStyle(
                      fontSize: size.width*0.04,
                      color: Colors.white
                    ),)
                )
              ],
            ),
          )
        ],
      ),
    );
  }


}
