import 'dart:math';

import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/main_chat.dart';
import 'package:fe_mobile_chat_app/services/friend_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:flutter/material.dart';

class FunctionService {
  static CircleAvatar createAvatar(String? imgUrl, Size size, String userName, String TYPE) {
    Color randomColor = getRamdomColor();
    var radiusValue;
    var fontSizeValue;
    switch(TYPE){
      case "CHAT": {
        radiusValue = size.width * 0.04;
        fontSizeValue = size.width * 0.04;
      }
      case "LIST-CHAT": {
        radiusValue = size.width * 0.05;
        fontSizeValue = size.width * 0.05;
      }
      case "PROFILE": {
        radiusValue = size.width * 0.1;
        fontSizeValue = size.width * 0.1;
      }
      case "USER-DETAIL": {
        radiusValue = size.width * 0.08;
        fontSizeValue = size.width * 0.08;
      }
      default: {
        radiusValue = size.width * 0.1;
        fontSizeValue = size.width * 0.05;
      }
    }
    if (imgUrl == "" || imgUrl == null || imgUrl == "null") {
      return CircleAvatar(
        radius: radiusValue,
        backgroundColor: randomColor,
        child: Text(
          userName.substring(0, 1),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: fontSizeValue),
        ),
      );
    } else {
      return CircleAvatar(
        radius: radiusValue,
        backgroundImage: NetworkImage(imgUrl),
      );
    }
  }



  static Color getRamdomColor() {
    Random random = Random();
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }

  // static List<User> searchFriends(String? current_phone) {
  //   List<User> searchResults = List.empty();
  //   if (current_phone!.isNotEmpty) {
  //     Future<List<Friend>> friends = FriendServiceImpl.getFriendListOfCurrentUser(current_phone).then((value) => {
  //
  //     });
  //     searchResults = friends
  //         .where((friend) =>
  //         friend.name!.toLowerCase().contains(current_phone.toLowerCase())).toList();
  //     return searchResults;
  //   } else {
  //     return searchResults;
  //   }
  // }

  static String dateFormat(DateTime date) {
    return '${date.day}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(2, '0')}';
  }
}