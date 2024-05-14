class Attach {
  String? url;
  String? name;

  Attach({
    this.url,
    this.name,
  });

  Attach copyWith({
    String? url,
    String? name,
  }) =>
      Attach(
        url: url ?? this.url,
        name: name ?? this.name,
      );

  Attach.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return 'Attach{url: $url, name: $name}';
  }
}
