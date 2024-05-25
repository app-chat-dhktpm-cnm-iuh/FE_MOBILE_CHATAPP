class FriendRequest {
  String? id;
  String? sender_phone;
  String? receiver_phone;
  bool? aceppted;

  FriendRequest(
      {this.id,
        this.sender_phone,
        this.receiver_phone,
        this.aceppted});

  FriendRequest copyWith({
    String? id,
    String? sender_phone,
    String? receiver_phone,
    bool? aceppted,
  }) =>
      FriendRequest(
        id: id ?? this.id,
        sender_phone: sender_phone ?? this.sender_phone,
        receiver_phone: receiver_phone ?? this.receiver_phone,
        aceppted: aceppted ?? this.aceppted,
      );

  FriendRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender_phone = json['sender_phone'];
    receiver_phone = json['receiver_phone'];
    aceppted = json['aceppted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_phone'] = sender_phone;
    data['receiver_phone'] = receiver_phone;
    data['aceppted'] = aceppted;
    return data;
  }

  @override
  String toString() {
    return 'FriendRequest{id: $id, sender_phone: $sender_phone, receiver_phone: $receiver_phone, aceppted: $aceppted}';
  }
}