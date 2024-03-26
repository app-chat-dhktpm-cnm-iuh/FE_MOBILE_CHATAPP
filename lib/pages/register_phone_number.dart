import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RegPhoneNumber extends StatelessWidget {
  const RegPhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    bool checkedValue = false;
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
                padding: EdgeInsets.all(paddingSize.vertical*1.5),
                child: Text("Tạo tài khoản",
                  style: TextStyle(
                      fontSize: size.height*0.04,
                      fontWeight: FontWeight.bold,
                      color: lightGreen),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingSize.vertical*0.42),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                        color: darkGreen,
                        fontSize: size.height*0.03,
                        fontWeight: FontWeight.w400),
                    decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: 5),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: darkGreen)
                        ),
                        hintText: "Nhập số điện thoại"
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.only(bottom: paddingSize.vertical*0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        side: const BorderSide(color: greyDark),
                        activeColor: darkGreen,
                        onChanged: (value) {},
                        value: checkedValue, ),
                      Text("Tôi đồng ý với các điều khoản sử dụng",
                          style: TextStyle(
                              fontSize: size.height*0.024,
                              fontWeight: FontWeight.normal)
                      )
                    ],
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
                  child: Text("Tiếp tục",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height*0.03))
              )
            ],
          ),
        )
    );
  }
}
