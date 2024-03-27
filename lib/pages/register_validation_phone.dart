import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/register_create_password.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RegValidatePhoneNumber extends StatefulWidget {
  const RegValidatePhoneNumber({super.key});

  @override
  State<RegValidatePhoneNumber> createState() => _RegValidatePhoneNumberState();
}

class _RegValidatePhoneNumberState extends State<RegValidatePhoneNumber> {
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
              Navigator.pop(context, PageTransition(child: const HomePage(), type: PageTransitionType.leftToRight));
            },
            color: darkGreen,
            icon: const Icon(Icons.arrow_back),),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: paddingSize.vertical*1.5, bottom: paddingSize.vertical*0.3),
                child: Text("Nhập mã xác thực",
                  style: TextStyle(
                      fontSize: size.height*0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical*0.42),
                child: Text("Mã xác thực đã được gửi tới 09***84",
                    style: TextStyle(
                        fontSize: size.height*0.024,
                        fontWeight: FontWeight.normal)),
              ),
              SizedBox(
                width: size.width*0.5,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: paddingSize.vertical*0.6,
                      top: paddingSize.vertical*0.6
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: paddingSize.vertical*1.5,
                        height: paddingSize.vertical*1.5,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height*0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: darkGreen)
                                  )
                          ),
                        ),
                      ),
                      SizedBox(
                      width: paddingSize.vertical*1.5,
                      height: paddingSize.vertical*1.5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                            color: darkGreen,
                            fontSize: size.height*0.03,
                            fontWeight: FontWeight.w400),
                        decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: greyDark)
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: 5),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: darkGreen)
                            )
                        ),
                      ),
                    ),
                      SizedBox(
                        width: paddingSize.vertical*1.5,
                        height: paddingSize.vertical*1.5,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height*0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: darkGreen)
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        width: paddingSize.vertical*1.5,
                        height: paddingSize.vertical*1.5,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: size.height*0.03,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: greyDark)
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: darkGreen)
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width*0.65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Không nhận được mã ?",
                      style: TextStyle(
                        fontSize: size.height*0.024,
                        fontWeight: FontWeight.normal)
                    ),
                    InkWell(
                      child: Text("Gửi lại mã",
                          style: TextStyle(
                              fontSize: size.height*0.024,
                              fontWeight: FontWeight.bold,
                              color: darkGreen)
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: paddingSize.vertical),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, PageTransition(
                          child: const RegCreatePassword(),
                          type: PageTransitionType.rightToLeft));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(darkGreen),
                        fixedSize: MaterialStateProperty.all(
                            Size(
                                size.width * 0.7,
                                size.height * 0.065
                            )
                        )),
                    child: Text("Xác nhận",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height*0.03))
                ),
              )
            ],
          ),
        )
    );
  }
}
