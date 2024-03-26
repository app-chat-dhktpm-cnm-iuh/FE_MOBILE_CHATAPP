import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor
      ),
      home: const HomePage(),
    );
  }
}
