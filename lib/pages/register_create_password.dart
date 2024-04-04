import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/register_phone_number.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RegCreatePassword extends StatefulWidget {
  const RegCreatePassword({super.key});

  @override
  State<RegCreatePassword> createState() => _RegCreatePasswordState();
}

class _RegCreatePasswordState extends State<RegCreatePassword> {
  final _controllerPass1 = TextEditingController();
  final _controllerPass2 = TextEditingController();
  var _valuePhone;
  var _errorPass1 = null;
  var _errorPass2 = null;
  bool _showPass1 = true;
  bool _showPass2 = true;

  void validatePhone(String value) {
    _valuePhone = _controllerPass1.text;
    RegExp regexPass= RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[()+\-\/!@#$%^&*]).{6,}$');
    _errorPass1 = null;

    if (value == '') {
      _errorPass1 = null;
    } else if (!regexPass.hasMatch(value)) {
      _errorPass1 = "Mật khẩu phải chứa ít nhất 6 ký tự gồm chữ hoa,\n"
          "chữ thường, số và ký tự đặc biệt";
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)?.settings.arguments as User;

    final  size = MediaQuery.of(context).size;
    final paddingSize = MediaQuery.of(context).padding;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, PageTransition(child: const RegPhoneNumber(), type: PageTransitionType.leftToRight));
            },
            color: darkGreen,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(paddingSize.vertical*0.5),
                child: Text("Tạo mật khẩu",
                  style: TextStyle(
                      fontSize: size.height*0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: TextField(
                  controller: _controllerPass1,
                  onChanged: (value) {
                    setState(() {
                      validatePhone(value);
                    });
                  },
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                      color: darkGreen,
                      fontSize: size.height*0.03,
                      fontWeight: FontWeight.w400),
                  obscureText: _showPass1,
                  decoration:  InputDecoration(
                      errorText: _errorPass1,
                      suffixIconConstraints: BoxConstraints(maxHeight: paddingSize.vertical*0.5),
                      suffixIcon: InkWell(
                          child: Icon(Icons.remove_red_eye,
                            size: paddingSize.vertical,
                            color: darkGreen
                          ),
                        onTapDown: (details) {
                          setState(() {
                            _showPass1 = false;
                          });
                        },
                        onTapUp: (details) {
                            setState(() {
                              _showPass1 = true;
                            });
                        },
                      ),
                      isDense: true,
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: darkGreen)
                      ),
                      hintText: "Nhập mật khẩu"
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical*1.5),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.only(top: paddingSize.top),
                    child: TextField(
                      controller: _controllerPass2,
                      onChanged: (value) {
                        if(value != _controllerPass1.text) {
                          setState(() {
                            _errorPass2 = "Mật khẩu chưa khớp";
                          });
                        } else {
                          setState(() {
                            _errorPass2 = null;
                          });
                        }
                      },
                      style: TextStyle(
                          color: darkGreen,
                          fontSize: size.height*0.03,
                          fontWeight: FontWeight.w400
                      ),
                      obscureText: _showPass2,
                      decoration: InputDecoration(
                          errorText: _errorPass2,
                          isDense: true,
                          suffixIconConstraints: BoxConstraints(maxHeight: paddingSize.vertical*0.5),
                          suffixIcon: InkWell(
                              child: Icon(Icons.remove_red_eye,
                                size: paddingSize.vertical,
                                color: darkGreen,
                              ),
                            onTapDown: (details) {
                              setState(() {
                                _showPass2 = false;
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                _showPass2 = true;
                              });
                            },
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: darkGreen)
                          ),
                          hintText: "Nhập mật khẩu mới"
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                      if(_errorPass1 == null && _errorPass2 == null) {
                          user = user.copyWith(password: _controllerPass2.text);
                          UserServices.register(user);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đăng nhập thành công")));
                      }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreen),
                      fixedSize: MaterialStateProperty.all(
                          Size(
                              size.width * 0.7,
                              size.height * 0.065
                          )
                      )),
                  child: Text("Tiếp tục", style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height*0.03))
              )
            ],
          ),
        )
    );
  }
}
