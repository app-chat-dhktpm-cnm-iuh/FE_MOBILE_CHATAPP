class Friend {
  String? phone_user;
  bool? is_blocked;

  Friend(
      {this.phone_user,
        this.is_blocked});

  Friend copyWith({
    String? phone_user,
    bool? is_blocked,
  }) =>
      Friend(
        phone_user: phone_user ?? this.phone_user,
        is_blocked: is_blocked ?? this.is_blocked,
      );

  Friend.fromJson(Map<String, dynamic> json) {
    phone_user = json['phone_user'];
    is_blocked = json['is_blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_user'] = phone_user;
    data['_blocked'] = is_blocked;
    return data;
  }

  @override
  String toString() {
    return 'Friend{phone_user: $phone_user, is_blocked: $is_blocked}';
  }
}