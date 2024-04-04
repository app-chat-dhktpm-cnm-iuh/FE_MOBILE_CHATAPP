import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/controllers/otp_service.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/register_validation_phone.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class RegPhoneNumber extends StatefulWidget {
  const RegPhoneNumber({super.key});

  @override
  State<RegPhoneNumber> createState() => _RegPhoneNumberState();
}

class _RegPhoneNumberState extends State<RegPhoneNumber> {
  final _controllerPhone = TextEditingController();
  var _errorPhone;
  var _valuePhone;
  bool? checkedValue = false;
  bool validPhone = false;

  void validatePhone(String value) {
    _valuePhone = _controllerPhone.text;
    RegExp regexPhone = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b');
    _errorPhone = null;

    if (value == '') {
      _errorPhone = null;
    } else if (!regexPhone.hasMatch(value)) {
      _errorPhone = "Số điện thoại không hợp lệ";
    } else
      validPhone = true;
  }

  @override
  void dispose() {
    _controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)?.settings.arguments as User;
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
                padding: EdgeInsets.all(paddingSize.vertical * 1.5),
                child: Text(
                  "Tạo tài khoản",
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.42),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: _controllerPhone,
                    onChanged: (inputPhone) {
                      setState(() {
                        validatePhone(inputPhone);
                      });
                    },
                    style: TextStyle(
                        color: darkGreen,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        isDense: true,
                        errorText: _errorPhone,
                        errorStyle: TextStyle(fontSize: size.height * 0.02),
                        contentPadding: const EdgeInsets.only(bottom: 5),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: darkGreen)),
                        hintText: "Nhập số điện thoại"),
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.only(bottom: paddingSize.vertical * 0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        side: const BorderSide(color: greyDark),
                        activeColor: darkGreen,
                        onChanged: (newValue) {
                          setState(() {
                            this.checkedValue = newValue;
                            if (newValue! && validPhone) {
                              _errorPhone = null;
                            }
                          });
                        },
                        value: this.checkedValue,
                      ),
                      Text("Tôi đồng ý với các điều khoản sử dụng",
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_valuePhone.isEmpty) {
                      setState(() {
                        _errorPhone = "Số điện thoại không được bỏ trống";
                      });
                    } else if (_errorPhone == null && !checkedValue!) {
                      setState(() {
                        _errorPhone = "Bạn phải đồng ý với điều khoản";
                      });
                    } else if (_errorPhone != null) {
                      return;
                    } else if (_errorPhone == null && checkedValue!) {
                      var result =
                          await UserServices.checkExistedPhone(_valuePhone);
                      if (result.body == "false") {
                        _errorPhone = null;
                        user = user.copyWith(phone: _valuePhone);
                        OTPService.sentOTP(
                            phone: "+84" + _valuePhone.toString().substring(1, 10),
                            errorStep: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Center(
                                  child: Text(
                                    "Lỗi gửi mã xác thực",
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ));
                            },
                            nextStep: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Center(
                                  child: Text(
                                    "Gửi mã xác thực thành công",
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ),
                                backgroundColor: lightGreen,
                              ));
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const RegValidatePhoneNumber(),
                                      type: PageTransitionType.rightToLeft,
                                      settings:
                                          RouteSettings(arguments: user)));
                            });
                      } else {
                        // setState(() {
                        //   _errorPhone = "Số điện thoại này đã được đăng ký";
                        // });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Center(
                            child: Text(
                              "Số điện thoại đã được đăng ký",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
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
