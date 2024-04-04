import 'dart:core';
import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/register_phone_number.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../model/User.dart';

class RegAccountName extends StatefulWidget {
  const RegAccountName({super.key});

  @override
  State<RegAccountName> createState() => _RegAccountName();
}

class _RegAccountName extends State<RegAccountName> {
  final _controller = TextEditingController();
  var _errorName;
  var user = User();

  void validateUserName(String value) {
    RegExp regexNumber = RegExp(r"[0-9_]");
    RegExp regexSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>_=+-;]');
    RegExp regexValidName = RegExp(r'[A-za-z ]{2,40}');
    _errorName = null;

    if(regexNumber.hasMatch(value)) {
       _errorName = "Tên không được chứa số" ;
    } else if (regexSpecialCharacter.hasMatch(value)) {
       _errorName =  "Tên không được chứa kí tự đặc biệt";
    } else if(value == '') {
       _errorName = null;
    } else if (!regexValidName.hasMatch(value)) {
       _errorName = "Tên không hợp lệ. Xin hãy đọc kỹ lưu ý";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      child: const HomePage(),
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
                padding: EdgeInsets.all(paddingSize.vertical * 1),
                child: Text(
                  "Tên tài khoản",
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.3),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: TextField(
                    onChanged: (inputText) => setState(() {
                      validateUserName(inputText);
                    }),
                    controller: _controller,
                    style: TextStyle(
                        color: darkGreen,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.only(bottom: 5),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: darkGreen)),
                        hintText: "Nhập tên tài khoản",
                        errorText: _errorName,
                        errorStyle: TextStyle(
                          fontSize: size.height*0.02
                        )
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: paddingSize.vertical * 0.3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text("Lưu ý",
                              style: TextStyle(
                                  fontSize: size.height * 0.024,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: paddingSize.vertical * 0.2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text("Tên tài khoản phải từ 2 - 40 kí tự",
                              style: TextStyle(
                                  fontSize: size.height * 0.024,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: paddingSize.vertical * 0.5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                              "Tên tài khoản nên là tên thật để bạn bè dễ dàng tìm kiếm bạn.",
                              style: TextStyle(
                                  fontSize: size.height * 0.024,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed:(){setState(() {
                    if( _controller.text.isEmpty) {
                      _errorName = "Chưa nhập tên";
                    } else if(_errorName == null) {
                      user = user.copyWith(name:  _controller.text);
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const RegPhoneNumber(),
                              type: PageTransitionType.rightToLeft,
                              settings: RouteSettings(arguments: user)
                          )
                      );
                    }
                  });},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreen),
                      fixedSize: MaterialStateProperty.all(
                          Size(size.width * 0.7, size.height * 0.065))),
                  child: Text("Tiếp tục",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.03)))
            ],
          ),
        ));
  }
}
