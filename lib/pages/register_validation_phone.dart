import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/controllers/otp_service.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/register_create_password.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class RegValidatePhoneNumber extends StatefulWidget {
  StompManager stompManager;
  RegValidatePhoneNumber({super.key, required this.stompManager});

  @override
  State<RegValidatePhoneNumber> createState() => _RegValidatePhoneNumberState();
}

class _RegValidatePhoneNumberState extends State<RegValidatePhoneNumber> {
  String errorCode = "";

  String setStringPhone(String? phone) {
    return '${phone!.substring(0, 2)}***${phone!.substring(8, 10)}';
  }

  final _controllerNum1 = TextEditingController();
  final _controllerNum2 = TextEditingController();
  final _controllerNum3 = TextEditingController();
  final _controllerNum4 = TextEditingController();
  final _controllerNum5 = TextEditingController();
  final _controllerNum6 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)?.settings.arguments as User;
    final FocusScopeNode focus = FocusScope.of(context);

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
                padding: EdgeInsets.only(
                    top: paddingSize.vertical * 1.5,
                    bottom: paddingSize.vertical * 0.3),
                child: Text(
                  "Nhập mã xác thực",
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.42),
                child: Column(
                  children: [
                    Text(
                        "Mã xác thực đã được gửi tới ${setStringPhone(user.phone)}",
                        style: TextStyle(
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.normal)),
                    Text(errorCode,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ),
              SizedBox(
                width: size.height*0.43,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: paddingSize.vertical * 0.6,
                      top: paddingSize.vertical * 0.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllerNum1,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {
                            if (value.length == 1) {focus.nextFocus()},
                          },
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: darkGreen))),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _controllerNum2,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {
                            if (value.length == 1) {focus.nextFocus()}
                          },
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: darkGreen))),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _controllerNum3,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {
                            if (value.length == 1) {focus.nextFocus()}
                          },
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: darkGreen))),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _controllerNum4,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {
                            if (value.length == 1) {focus.nextFocus()}
                          },
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: darkGreen))),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _controllerNum5,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {
                            if (value.length == 1) {focus.nextFocus()}
                          },
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: darkGreen))),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _controllerNum6,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {
                            if (value.length == 1) {focus.nextFocus()}
                          },
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: darkGreen))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Không nhận được mã ?",
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.normal)),
                    InkWell(
                      child: Text("Gửi lại mã",
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: darkGreen)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: paddingSize.vertical),
                child: ElevatedButton(
                    onPressed: () {

                      String code = _controllerNum1.text +
                          _controllerNum2.text +
                          _controllerNum3.text +
                          _controllerNum4.text +
                          _controllerNum5.text +
                          _controllerNum6.text;

                      if (code.isEmpty) {
                        setState(() {
                          errorCode = "Mã không được bỏ trống";
                        });
                      } else {
                        OTPService.verifyOTP(otp: code).then((value) => {
                              if (value == "Success")
                                {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: RegCreatePassword(stompManager: widget.stompManager,),
                                          type: PageTransitionType.rightToLeft,
                                          settings: RouteSettings(arguments: user)
                                      ))
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Center(
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ))
                                }
                            });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(darkGreen),
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * 0.7, size.height * 0.065))),
                    child: Text("Xác nhận",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.03))),
              )
            ],
          ),
        ));
  }
}
