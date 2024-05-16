import 'package:fe_mobile_chat_app/model/Attach.dart';

class MessageRequest {
  String? conversation_id;
  List<String>? members;
  String? content;
  String? sender_name;
  List<String>? images;
  List<Attach>? attaches;
  String? sender_phone;
  String? sender_avatar_url;
  DateTime? sent_date_time;
  bool? is_read;

  MessageRequest(
      {this.conversation_id,
      this.members,
      this.content,
      this.sender_name,
      this.images,
      this.attaches,
      this.sender_phone,
      this.sender_avatar_url,
      this.sent_date_time,
      this.is_read});

  MessageRequest copyWith(
          {String? conversation_id,
          List<String>? members,
          String? content,
          String? sender_name,
          List<String>? images,
          List<Attach>? attaches,
          String? sender_phone,
          String? sender_avatar_url,
          DateTime? sent_date_time,
          bool? is_read}) =>
      MessageRequest(
          conversation_id: conversation_id ?? this.conversation_id,
          members: members ?? this.members,
          content: content ?? this.content,
          sender_name: sender_name ?? this.sender_name,
          images: images ?? this.images,
          attaches: attaches ?? this.attaches,
          sender_phone: sender_phone ?? this.sender_phone,
          sender_avatar_url: sender_avatar_url ?? this.sender_avatar_url,
          sent_date_time: sent_date_time ?? this.sent_date_time,
          is_read: is_read ?? this.is_read);

  MessageRequest.fromJson(Map<String, dynamic> json) {
    conversation_id = json['conversation_id'];

    List<dynamic> memberJson = json['members'] as List<dynamic>;
    members = memberJson.map((dynamic item) {
      return item.toString();
    }).toList();

    content = json['content'];
    sender_name = json['sender_name'];
    List<dynamic> imagesJson = json['images'] as List<dynamic>;
    images = imagesJson.map((dynamic item) {
      return item.toString();
    }).toList();

    List<dynamic> attchesJson = json['attaches'] as List<dynamic>;
    attaches = attchesJson.map((dynamic item) {
      return Attach.fromJson(item);
    }).toList();

    sender_phone = json['sender_phone'];
    sender_avatar_url = json['sender_avatar_url'];
    sent_date_time = DateTime.fromMillisecondsSinceEpoch(json['sent_date_time']);
    is_read = json['_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversation_id'] = conversation_id;
    data['members'] = members;
    data['content'] = content;
    data['sender_name'] = sender_name;
    data['images'] = images;
    data['attaches'] = attaches;
    data['sender_phone'] = sender_phone;
    data['sender_avatar_url'] = sender_avatar_url;
    data['sent_date_time'] = sent_date_time?.toIso8601String();
    data['_read'] = is_read;
    return data;
  }

  @override
  String toString() {
    return 'MessageRequest{conversation_id: $conversation_id, members: $members, content: $content, sender_name: $sender_name, images: $images, attaches: $attaches, sender_phone: $sender_phone, sender_avatar_url: $sender_avatar_url, sent_date_time: $sent_date_time, is_read: $is_read}';
  }
}