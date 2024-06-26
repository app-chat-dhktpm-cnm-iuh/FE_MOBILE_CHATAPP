import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/login_page.dart';
import 'package:fe_mobile_chat_app/pages/register_account_name.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class HomePage extends StatelessWidget {
  StompManager stompManager;
  HomePage({super.key, required this.stompManager});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingSize = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: FractionallySizedBox(
              heightFactor: 0.6,
              widthFactor: 1,
              child: SvgPicture.asset("assets/images/Logo.svg"))),
            Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                  children:[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, PageTransition(child: Login(stompManager: stompManager,), type: PageTransitionType.rightToLeft));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(darkGreen),
                            fixedSize: MaterialStateProperty.all(
                                Size(
                                    size.width * 0.7,
                                    size.height * 0.065
                                )
                            )),
                        child: Text("Đăng nhập", style: TextStyle(color: Colors.white, fontSize: size.height * 0.02))),
                    Padding(
                      padding:  EdgeInsets.only(top: paddingSize.top*0.3),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, PageTransition(child: RegAccountName(stompManager: stompManager,), type: PageTransitionType.rightToLeft));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(lightGreen),
                              fixedSize: MaterialStateProperty.all(
                                  Size(
                                      size.width * 0.7,
                                      size.height * 0.065
                                  )
                              )),
                          child: Text("Đăng ký", style: TextStyle(color: Colors.white, fontSize: size.height * 0.02))),
                    )]
              ),
            ),
          )],)
        )
      );
  }
}


