import 'dart:convert';
import 'dart:io';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class Login extends StatefulWidget {
  final StompManager stompManager;
  const Login({super.key, required this.stompManager});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controllerPhone = TextEditingController();
  final _controllerPass = TextEditingController();
  var _error = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingSize = MediaQuery.of(context).padding;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  PageTransition(
                      child: HomePage(stompManager: widget.stompManager,),
                      type: PageTransitionType.leftToRight));
            },
            color: darkGreen,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(paddingSize.vertical),
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              Text(
                _error,
                style:
                    TextStyle(fontSize: size.height * 0.02, color: Colors.red),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.2),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: TextField(
                    controller: _controllerPhone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: darkGreen,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.w400),
                    decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: 5),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkGreen)),
                        hintText: "Số điện thoại"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.5),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.only(top: paddingSize.top),
                    child: TextField(
                      controller: _controllerPass,
                      style: TextStyle(
                          color: darkGreen,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.w400),
                      obscureText: true,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 5),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: darkGreen)),
                          hintText: "Mật khẩu"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.7),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: size.width * 0.4,
                    child: InkWell(
                      child: Text("Quên mật khẩu ?",
                          style: TextStyle(
                              fontSize: size.height * 0.024,
                              fontWeight: FontWeight.bold,
                              color: lightGreen)),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    User user = User();
                    UserToken userWithToken = UserToken();
                    String responseBody;
                    user = user.copyWith(
                        phone: _controllerPhone.text,
                        password: _controllerPass.text,
                        role: "USER");
                    await UserServices.login(user).then((value) => {
                          responseBody = utf8.decode(value.bodyBytes),
                          userWithToken = UserToken.fromJson(jsonDecode(responseBody)),
                          if (value.statusCode == 202)
                            {
                              widget.stompManager.sendStompMessage("/app/user.userOnline", JsonEncoder().convert(user.toJson())),
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: MainChat(stompManager: widget.stompManager,),
                                      type: PageTransitionType.rightToLeft,
                                      settings: RouteSettings(
                                          arguments: userWithToken)))
                            }
                          else
                            {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Đăng nhập không thành công",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ))
                            }
                        });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreen),
                      fixedSize: MaterialStateProperty.all(
                          Size(size.width * 0.7, size.height * 0.065))),
                  child: Text("Đăng nhập",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.03)))
            ],
          ),
        ));
  }
}
