class User {
  String? phone;
  String? password;
  String? name;
  String? dateOfBirth;
  bool? gender;
  bool? isActived;
  String? avatarUrl;
  List<User>? friendsList;

  User(
      {this.phone,
      this.password,
      this.name,
      this.dateOfBirth,
      this.gender,
      this.isActived,
      this.avatarUrl,
      this.friendsList});

  User copyWith({
    String? phone,
    String? password,
    String? name,
    String? dateOfBirth,
    bool? gender,
    bool? isActived,
    String? avatarUrl,
    List<User>? friendsList,
  }) =>
      User(
          phone: phone ?? this.phone,
          password: password ?? this.password,
          name: name ?? this.name,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          gender: gender ?? this.gender,
          isActived: isActived ?? this.isActived,
          avatarUrl: avatarUrl ?? this.avatarUrl,
          friendsList: friendsList ?? this.friendsList);

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    isActived = json['is_actived'];
    avatarUrl = json['avatar_url'];
    friendsList = json['friends_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['password'] = password;
    data['name'] = name;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['is_actived'] = isActived;
    data['avatar_url'] = avatarUrl;
    data['friends_list'] = friendsList;
    return data;
  }
}
