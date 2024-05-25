import 'dart:convert';

import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/services/friend_service.dart';

class FriendServiceImpl {

  static Future<List<User>> getFriendListOfCurrentUser(String? current_phone) async {
    List<User> friends = List.empty();
    print(current_phone);
    List<dynamic> friendsDynamic;
    String body = "";
    await FriendService.getFriendListCurrentPhone(current_phone).then((value) => {
      body = utf8.decode(value.bodyBytes),
      friendsDynamic = jsonDecode(body),
      friends = friendsDynamic.map((user) => User.fromJson(user)).toList()
    });
    return friends;
  }

  static Future<List<FriendRequest>> getFriendRequestList(String? current_phone) async {
    List<FriendRequest> friendRequests = List.empty();
    List<dynamic> friendRequestsDynamic;
    String body = "";
    await FriendService.getFriendRequestList(current_phone).then((value) => {
      body = utf8.decode(value.bodyBytes),
      friendRequestsDynamic = jsonDecode(body),
      friendRequests = friendRequestsDynamic.map((friendRequest) => FriendRequest.fromJson(friendRequest)).toList()
    });
    return friendRequests;
  }
}