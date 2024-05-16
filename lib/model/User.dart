import 'package:fe_mobile_chat_app/model/Friend.dart';

class User {
  String? user_id;
  String? phone;
  String? password;
  String? name;
  String? dateOfBirth;
  bool? gender;
  bool? is_activated;
  String? avatarUrl;
  List<Friend>? friendsList;
  String? role;

  User(
      {this.user_id,
      this.phone,
      this.password,
      this.name,
      this.dateOfBirth,
      this.gender,
      this.is_activated,
      this.avatarUrl,
      this.friendsList,
      this.role});

  User copyWith(
          {String? user_id,
          String? phone,
          String? password,
          String? name,
          String? dateOfBirth,
          bool? gender,
          bool? is_activated,
          String? avatarUrl,
          List<Friend>? friendsList,
          String? role}) =>
      User(
          user_id: user_id ?? this.user_id,
          phone: phone ?? this.phone,
          password: password ?? this.password,
          name: name ?? this.name,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          gender: gender ?? this.gender,
          is_activated: is_activated ?? this.is_activated,
          avatarUrl: avatarUrl ?? this.avatarUrl,
          friendsList: friendsList ?? this.friendsList,
          role: role ?? this.role);

  User.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    phone = json['phone'];
    password = json['password'];
    name = json['name'];
    if(json['date_of_birth'].runtimeType == String) {
      dateOfBirth = DateTime.parse(json['date_of_birth']).toString();
    } else if(json['date_of_birth'].runtimeType == int) {
      dateOfBirth = DateTime.fromMillisecondsSinceEpoch(json['date_of_birth']).toString();
    } else {
      dateOfBirth = json['date_of_birth'];
    }
    gender = json['gender'];
    is_activated = json['_activated'];
    avatarUrl = json['avatar_url'];

    List<dynamic> friendsJson = json['friends_list'] as List<dynamic>;
    friendsList = friendsJson.map((dynamic item) {
      return Friend.fromJson(item);
    }).toList();

    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
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

  @override
  String toString() {
    return 'User{user_id: $user_id, phone: $phone, password: $password, name: $name, dateOfBirth: $dateOfBirth, gender: $gender, is_activated: $is_activated, avatarUrl: $avatarUrl, friendsList: $friendsList, role: $role}';
  }
}
