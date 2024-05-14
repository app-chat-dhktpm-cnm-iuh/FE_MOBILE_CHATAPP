import 'package:fe_mobile_chat_app/model/Attach.dart';

class Message {
  String? message_id;
  String? sender_phone;
  String? sender_name;
  String? content;
  String? sender_avatar_url;
  List<String>? images;
  List<Attach>? attaches;
  DateTime? sent_date_time;
  List<String>? phoneDeleteList;
  bool? is_read;
  bool? is_notification;

  Message(
      {this.message_id,
      this.sender_phone,
      this.sender_name,
      this.content,
      this.sender_avatar_url,
      this.images,
      this.attaches,
      this.sent_date_time,
      this.phoneDeleteList,
      this.is_read,
      this.is_notification});

  Message copyWith(
          {String? message_id,
          String? sender_phone,
          String? sender_name,
          String? content,
          String? sender_avatar_url,
          List<String>? images,
          List<Attach>? attaches,
          DateTime? sent_date_time,
          List<String>? phoneDeleteList,
          bool? is_read,
          bool? is_notification}) =>
      Message(
          message_id: message_id ?? this.message_id,
          sender_phone: sender_phone ?? this.sender_phone,
          sender_name: sender_name ?? this.sender_name,
          content: content ?? this.content,
          sender_avatar_url: sender_avatar_url ?? this.sender_avatar_url,
          images: images ?? this.images,
          attaches: attaches ?? this.attaches,
          sent_date_time: sent_date_time ?? this.sent_date_time,
          phoneDeleteList: phoneDeleteList ?? this.phoneDeleteList,
          is_read: is_read ?? this.is_read,
          is_notification: is_notification ?? this.is_notification);

  Message.fromJson(Map<String, dynamic> json) {
    message_id = json['message_id'];
    sender_phone = json['sender_phone'];
    sender_name = json['sender_name'];
    content = json['content'];
    sender_avatar_url = json['sender_avatar_url'];

    List<dynamic> imageList = json['images'] as List<dynamic>;
    images = imageList.map((dynamic item) {
      return item.toString();
    }).toList();

    List<dynamic> attchesJson = json['attaches'] as List<dynamic>;
    attaches = attchesJson.map((dynamic item) {
      return Attach.fromJson(item);
    }).toList();

    sent_date_time = DateTime.parse(json['sent_date_time']);

    List<dynamic> deleteList = json['phoneDeleteList'] as List<dynamic>;
    phoneDeleteList = deleteList.map((dynamic item) {
      return item.toString();
    }).toList();

    is_read = json['_read'];
    is_notification = json['_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = message_id;
    data['sender_phone'] = sender_phone;
    data['sender_name'] = sender_name;
    data['content'] = content;
    data['sender_avatar_url'] = sender_avatar_url;
    data['images'] = images;
    data['attaches'] = attaches;
    data['sent_date_time'] = sent_date_time;
    data['phoneDeleteList'] = phoneDeleteList;
    data['_read'] = is_read;
    data['_notification'] = is_notification;
    return data;
  }

  @override
  String toString() {
    return 'Message{message_id: $message_id, sender_phone: $sender_phone, sender_name: $sender_name, content: $content, sender_avatar_url: $sender_avatar_url, images: $images, attaches: $attaches, sent_date_time: $sent_date_time, phoneDeleteList: $phoneDeleteList, is_read: $is_read, is_notification: $is_notification}';
  }
}
