/// Pure Dart model for Bookmark — stored locally via SharedPreferences.
class Bookmark {
  int id;
  String? type;
  String? title;
  String? link;
  DateTime? createdAt;

  Bookmark({
    this.id = 0,
    this.type,
    this.title,
    this.link,
    this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] ?? 0,
      type: json['type'],
      title: json['title'],
      link: json['link'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'link': link,
        'createdAt': createdAt?.toIso8601String(),
      };
}
