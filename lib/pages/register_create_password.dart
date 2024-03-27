import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/register_phone_number.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RegCreatePassword extends StatefulWidget {
  const RegCreatePassword({super.key});

  @override
  State<RegCreatePassword> createState() => _RegCreatePasswordState();
}

class _RegCreatePasswordState extends State<RegCreatePassword> {
  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.all(paddingSize.vertical*1.5),
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
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                      color: darkGreen,
                      fontSize: size.height*0.03,
                      fontWeight: FontWeight.w400),
                  obscureText: true,
                  decoration:  InputDecoration(
                      suffixIconConstraints: BoxConstraints(maxHeight: paddingSize.vertical*0.5),
                      suffixIcon: InkWell(
                          child: Icon(Icons.remove_red_eye,
                            size: paddingSize.vertical,
                            color: darkGreen
                          ),
                          onLongPress: () {}
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
                      style: TextStyle(
                          color: darkGreen,
                          fontSize: size.height*0.03,
                          fontWeight: FontWeight.w400
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          isDense: true,
                          suffixIconConstraints: BoxConstraints(maxHeight: paddingSize.vertical*0.5),
                          suffixIcon: InkWell(
                              child: Icon(Icons.remove_red_eye,
                                size: paddingSize.vertical,
                                color: darkGreen,
                              ),
                              onLongPress: () {}
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
                  onPressed: () {},
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
