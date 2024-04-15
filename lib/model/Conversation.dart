
import 'package:fe_mobile_chat_app/model/Message.dart';

class Conversation {
   String? conversation_id;
   String? title;
   String? creator_phone;
   String? ava_conversation_url;
   bool? is_deleted;
   List<String>? members;
   List<Message>? messages;

   Conversation(
       {this.conversation_id,
          this.title,
          this.creator_phone,
          this.ava_conversation_url,
          this.is_deleted,
          this.members,
          this.messages,});

   Conversation copyWith({
      String? conversation_id,
      String? title,
      String? creator_phone,
      String? ava_conversation_url,
      bool? is_deleted,
      List<String>? members,
      List<Message>? messages
   }) =>
       Conversation(
           conversation_id: conversation_id ?? this.conversation_id,
           title: title ?? this.title,
           creator_phone: creator_phone ?? this.creator_phone,
           is_deleted: is_deleted ?? this.is_deleted,
           members: members ?? this.members,
           messages: messages ?? this.messages,
           ava_conversation_url: ava_conversation_url ?? this.ava_conversation_url,
       );

   Conversation.fromJson(Map<String, dynamic> json) {
      conversation_id = json['conversation_id'];
      title = json['title'];
      creator_phone = json['creator_phone'];
      is_deleted = json['_deleted'];
      ava_conversation_url = json['ava_conversation_url'];

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
      data['creator_phone'] = creator_phone;
      data['_deleted'] = is_deleted;
      data['members'] = members;
      data['messages'] = messages;
      data['ava_conversation_url'] = ava_conversation_url;
      return data;
   }

   @override
  String toString() {
    return 'Conversation{conversation_id: $conversation_id, title: $title, creator_phone: $creator_phone, ava_conversation_url: $ava_conversation_url, is_deleted: $is_deleted, members: $members, messages: $messages}';
  }
}