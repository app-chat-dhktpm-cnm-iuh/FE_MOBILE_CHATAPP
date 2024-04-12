import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/firebase_options.dart';
import 'package:fe_mobile_chat_app/pages/home.dart';
import 'package:fe_mobile_chat_app/pages/login_page.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.debug,
  );
  final stompManager = StompManager();
  stompManager.connectToStomp();
  runApp(MyApp(stompManager: stompManager));
}

class MyApp extends StatelessWidget {
  final StompManager stompManager;
  MyApp({super.key, required this.stompManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
      home: HomePage(stompManager: stompManager),
    );
  }
}
