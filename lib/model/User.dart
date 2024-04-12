class User {
  String? phone;
  String? password;
  String? name;
  String? dateOfBirth;
  bool? gender;
  bool? is_activated;
  String? avatarUrl;
  List<User>? friendsList;
  String? role;

  User(
      {this.phone,
      this.password,
      this.name,
      this.dateOfBirth,
      this.gender,
      this.is_activated,
      this.avatarUrl,
      this.friendsList, this.role});

  User copyWith({
    String? phone,
    String? password,
    String? name,
    String? dateOfBirth,
    bool? gender,
    bool? isActived,
    String? avatarUrl,
    List<User>? friendsList,
    String? role
  }) =>
      User(
          phone: phone ?? this.phone,
          password: password ?? this.password,
          name: name ?? this.name,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          gender: gender ?? this.gender,
          is_activated: isActived ?? this.is_activated,
          avatarUrl: avatarUrl ?? this.avatarUrl,
          friendsList: friendsList ?? this.friendsList,
          role: role ?? this.role
      );

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    is_activated = json['_activated'];
    avatarUrl = json['avatar_url'];
    friendsList = json['friends_list'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['password'] = password;
    data['name'] = name;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['_activated'] = is_activated;
    data['avatar_url'] = avatarUrl;
    data['friends_list'] = friendsList;
    data['role'] = role;
    return data;
  }
}
