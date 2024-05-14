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
    deleted_at = json['deleted_at'];
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