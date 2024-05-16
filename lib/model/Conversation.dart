import 'package:fe_mobile_chat_app/model/DeleteConversationUser.dart';
import 'package:fe_mobile_chat_app/model/Message.dart';

class Conversation {
  String? conversation_id;
  String? title;
  bool? is_group;
  String? creator_phone;
  String? ava_conversation_url;
  List<DeleteConversationUser>? deleteConversationUsers;
  DateTime? updated_at;
  List<String>? members;
  List<Message>? messages;

  Conversation({
    this.conversation_id,
    this.title,
    this.is_group,
    this.creator_phone,
    this.ava_conversation_url,
    this.deleteConversationUsers,
    this.updated_at,
    this.members,
    this.messages,
  });

  Conversation copyWith(
          {String? conversation_id,
          String? title,
          bool? is_group,
          String? creator_phone,
          String? ava_conversation_url,
          List<DeleteConversationUser>? deleteConversationUsers,
          DateTime? updated_at,
          List<String>? members,
          List<Message>? messages}) =>
      Conversation(
        conversation_id: conversation_id ?? this.conversation_id,
        title: title ?? this.title,
        is_group: is_group ?? this.is_group,
        creator_phone: creator_phone ?? this.creator_phone,
        ava_conversation_url: ava_conversation_url ?? this.ava_conversation_url,
        deleteConversationUsers:
        deleteConversationUsers ?? this.deleteConversationUsers,
        updated_at: updated_at ?? this.updated_at,
        members: members ?? this.members,
        messages: messages ?? this.messages,
      );

  Conversation.fromJson(Map<String, dynamic> json) {
    conversation_id = json['conversation_id'];
    title = json['title'];
    is_group = json['_group'];
    creator_phone = json['creator_phone'];
    ava_conversation_url = json['ava_conversation_url'];

    List<dynamic> deleteUserJson =
        json['deleteConversationUsers'] as List<dynamic>;
    deleteConversationUsers = deleteUserJson.map((dynamic item) {
      return DeleteConversationUser.fromJson(item);
    }).toList();

    if(json['updated_at'].runtimeType == String) {
      updated_at = DateTime.parse(json['updated_at']);
    } else {
      updated_at = DateTime.fromMillisecondsSinceEpoch(json['updated_at']);
    }

    List<dynamic> memberJson = json['members'] as List<dynamic>;
    members = memberJson.map((dynamic item) {
      return item.toString();
    }).toList();

    List<dynamic> messageJson = json['messages'] as List<dynamic>;
    messages = messageJson.map((dynamic item) {
      return Message.fromJson(item);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversation_id'] = conversation_id;
    data['title'] = title;
    data['_group'] = is_group;
    data['creator_phone'] = creator_phone;
    data['ava_conversation_url'] = ava_conversation_url;
    data['deleteConversationUsers'] = deleteConversationUsers;
    data['updated_at'] = updated_at?.toIso8601String();
    data['members'] = members;
    data['messages'] = messages;
    return data;
  }

  @override
  String toString() {
    return 'Conversation{conversation_id: $conversation_id, title: $title, is_group: $is_group, creator_phone: $creator_phone, ava_conversation_url: $ava_conversation_url, deleteConversationUsers: $deleteConversationUsers, updated_at: $updated_at, members: $members, messages: $messages}';
  }
}
