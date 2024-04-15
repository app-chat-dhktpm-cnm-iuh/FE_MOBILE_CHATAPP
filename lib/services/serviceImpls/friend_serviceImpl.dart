import 'dart:convert';

import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/friend_service.dart';

class FriendServiceImpl {

  static Future<List<User>> getFriendListOfCurrentUser(String? current_phone) async {
    List<User> friends = List.empty();
    List<dynamic> friendsDynamic;
    String body = "";
    await FriendService.getFriendListCurrentPhone(current_phone).then((value) => {
      body = utf8.decode(value.bodyBytes),
      friendsDynamic = jsonDecode(body),
      friends = friendsDynamic.map((user) => User.fromJson(user)).toList()
    });
    return friends;
  }
}