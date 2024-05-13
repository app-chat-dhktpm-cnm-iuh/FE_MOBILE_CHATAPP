class Message {
  String? sender_phone;
  String? sender_name;
  String? content;
  List<String>? attaches;
  DateTime? sent_date_time;
  bool? is_deleted;
  bool? is_read;

  Message(
      {this.sender_phone,
      this.sender_name,
      this.content,
      this.attaches,
      this.sent_date_time,
      this.is_deleted,
      this.is_read});

  Message copyWith(
          {String? sender_phone,
          String? sender_name,
          String? content,
          List<String>? attaches,
          DateTime? sent_date_time,
          bool? is_deleted,
          bool? is_read}) =>
      Message(
          sender_phone: sender_phone ?? this.sender_phone,
          sender_name: sender_name ?? this.sender_name,
          content: content ?? this.content,
          attaches: attaches ?? this.attaches,
          is_deleted: is_deleted ?? this.is_deleted,
          sent_date_time: sent_date_time ?? this.sent_date_time,
          is_read: is_read ?? this.is_read);

  Message.fromJson(Map<String, dynamic> json) {
    sender_phone = json['sender_phone'];
    sender_name = json['sender_name'];
    content = json['content'];

    List<dynamic> attchesJson = json['attaches'] as List<dynamic>;
    attaches = attchesJson.map((dynamic item) {
      return item.toString();
    }).toList();

    is_deleted = json['is_deleted'];
    is_read = json['_read'];
    sent_date_time = DateTime.parse(json['sent_date_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_phone'] = sender_phone;
    data['sender_name'] = sender_name;

    data['content'] = content;
    data['attaches'] = attaches;
    data['_deleted'] = is_deleted;
    data['_read'] = is_read;
    data['sent_date_time'] = sent_date_time;
    return data;
  }

  @override
  String toString() {
    return 'Message{sender_phone: $sender_phone, sender_name: $sender_name, content: $content, attaches: $attaches, sent_date_time: $sent_date_time, is_deleted: $is_deleted, is_read: $is_read}';
  }
}
