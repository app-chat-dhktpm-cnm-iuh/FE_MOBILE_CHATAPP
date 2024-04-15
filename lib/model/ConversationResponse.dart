import 'package:fe_mobile_chat_app/model/Conversation.dart';
import 'package:fe_mobile_chat_app/model/User.dart';

class ConversationResponse {
  Conversation? conversation;
  List<User>? memberDetails;

  ConversationResponse({this.conversation, this.memberDetails});

  ConversationResponse copyWith(
          {Conversation? conversation, List<User>? memberDetails}) =>
      ConversationResponse(
          conversation: conversation ?? this.conversation,
          memberDetails: memberDetails ?? this.memberDetails);

  ConversationResponse.fromJson(Map<String, dynamic> json) {
    conversation = Conversation.fromJson(json['conversation']);
    List<dynamic> userJson = json['memberDetails'] as List<dynamic>;
    memberDetails = userJson.map((dynamic item) {
      return User.fromJson(item);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversation'] = conversation;
    data['memberDetails'] = memberDetails;
    return data;
  }

  @override
  String toString() {
    return 'ConversationResponse{conversation: $conversation, memberDetails: $memberDetails}';
  }
}
