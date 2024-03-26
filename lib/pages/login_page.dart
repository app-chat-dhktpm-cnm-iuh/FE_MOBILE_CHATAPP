import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
            Navigator.pop(context, PageTransition(child: HomePage(), type: PageTransitionType.leftToRight));
          },
          color: darkGreen,
          icon: Icon(Icons.arrow_back),),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(paddingSize.vertical*1.5),
              child: const Text("Đăng nhập",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: lightGreen),
                      ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: paddingSize.vertical*0.2),
              child: SizedBox(
                width: size.width * 0.8,
                child: const TextField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: darkGreen),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: darkGreen)
                      ),
                      hintText: "Số điện thoại"
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: paddingSize.vertical*0.5),
              child: SizedBox(
                width: size.width * 0.8,
                child: Padding(
                  padding: EdgeInsets.only(top: paddingSize.top),
                  child: const TextField(
                      style: TextStyle(color: darkGreen),
                      obscureText: true,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 5),
                          focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: darkGreen)
                          ),
                          hintText: "Mật khẩu"
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: paddingSize.vertical*0.7),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: size.width * 0.4,
                  child: InkWell(
                    child: const Text("Quên mật khẩu ?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: lightGreen)
                    ),
                    onTap: () {},
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
                child: const Text("Đăng nhập", style: TextStyle(color: Colors.white))
            )
          ],
        ),
      )
    );
  }
}
