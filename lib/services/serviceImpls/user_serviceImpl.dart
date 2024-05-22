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
    await UserServices.getUserDetailsByPhone(phone!).then((value) => {
      body = utf8.decode(value.bodyBytes),
      user = jsonDecode(body),
      userDetail = User.fromJson(user),
    });
    return userDetail;
  }

  static Future<User> updateUserDetail(
      User user) async {
    User userDetail = User();
    String body = "";
    dynamic userDetailDynamic;

      await UserServices.updateUserDetail(user).then((value) => {
        body = utf8.decode(value.bodyBytes),
        userDetailDynamic = jsonDecode(body),
        userDetail = User.fromJson(userDetailDynamic),
      });


    return userDetail;
  }
}