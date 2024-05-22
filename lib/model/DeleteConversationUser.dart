import 'package:flutter/material.dart';

class DeleteConversationUser {
  String? user_phone;
  DateTime? deleted_at;

  DeleteConversationUser(
      {this.user_phone,
        this.deleted_at,
  });

  DeleteConversationUser copyWith({
    String? user_phone,
    DateTime? deleted_at,
  }) =>
      DeleteConversationUser(
        user_phone: user_phone ?? this.user_phone,
        deleted_at: deleted_at ?? this.deleted_at,
      );

  DeleteConversationUser.fromJson(Map<String, dynamic> json) {
    user_phone = json['user_phone'];

    if(json['deleted_at'].runtimeType == String) {
      deleted_at = DateTime.parse(json['deleted_at']);
    } else if(json['deleted_at'].runtimeType == int) {
      deleted_at = DateTime.fromMillisecondsSinceEpoch(json['deleted_at']);
    } else {
      deleted_at = json['date_of_birth'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_phone'] = user_phone;
    data['deleted_at'] = deleted_at;
    return data;
  }

  @override
  String toString() {
    return 'DeleteConversationUser{user_phone: $user_phone, deleted_at: $deleted_at}';
  }
}