import 'package:fe_mobile_chat_app/model/User.dart';

class UserToken {
  User? user;
  String? token;

  UserToken({this.user, this.token});

  UserToken copyWith({User? user, String? token}) =>
      UserToken(user: user ?? this.user, token: token ?? this.token);

  UserToken.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    token = json['token'];
  }

  Map<String, dynamic> toJson () {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['token'] = token;
    return data;
  }

  @override
  String toString() {
    return 'UserToken{user: $user, token: $token}';
  }
}
