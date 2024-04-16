import 'dart:convert';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/user_service.dart';

class UserServiceImpl {
  static Future<User> getUserDetailByPhone(
      String? phone) async {
    User userDetail = User();
    dynamic user;
    String body = "";
    await UserServices.getUserDetailsByphone(phone!).then((value) => {
      body = utf8.decode(value.bodyBytes),
      user = jsonDecode(body),
      userDetail = User.fromJson(user),
    });
    return userDetail;
  }
}