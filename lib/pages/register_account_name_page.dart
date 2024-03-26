import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RegAccountName extends StatelessWidget {
  const RegAccountName({super.key});

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
                padding: EdgeInsets.all(paddingSize.vertical*1.5),
                child: Text("Tên tài khoản",
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
                        hintText: "Nhập tên tài khoản"
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingSize.vertical*0.3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text("Lưu ý",
                              style: TextStyle(
                                  fontSize: size.height*0.024,
                                  fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingSize.vertical*0.2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text("Tên tài khoản phải từ 2 - 40 kí tự",
                              style: TextStyle(
                                  fontSize: size.height*0.024,
                                  fontWeight: FontWeight.normal)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingSize.vertical*0.5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text("Tên tài khoản nên là tên thật để bạn bè dễ dàng tìm kiếm bạn.",
                              style: TextStyle(
                                  fontSize: size.height*0.024,
                                  fontWeight: FontWeight.normal)
                          ),
                        ),
                      ),
                    ),
                  ],
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
