/// Pure Dart model for DownloadedMalfuzat — stored locally via SharedPreferences.
class DownloadedMalfuzat {
  int id;
  String? malfuzatId;
  String? title;
  String? body;
  String? excerpt;
  String? audio;
  String? document;
  String? author;
  String? publishedAt;
  DateTime? createdAt;

  DownloadedMalfuzat({
    this.id = 0,
    this.malfuzatId,
    this.title,
    this.body,
    this.excerpt,
    this.audio,
    this.document,
    this.author,
    this.publishedAt,
    this.createdAt,
  });

  factory DownloadedMalfuzat.fromJson(Map<String, dynamic> json) {
    return DownloadedMalfuzat(
      id: json['id'] ?? 0,
      malfuzatId: json['malfuzatId'],
      title: json['title'],
      body: json['body'],
      excerpt: json['excerpt'],
      audio: json['audio'],
      document: json['document'],
      author: json['author'],
      publishedAt: json['publishedAt'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'malfuzatId': malfuzatId,
        'title': title,
        'body': body,
        'excerpt': excerpt,
        'audio': audio,
        'document': document,
        'author': author,
        'publishedAt': publishedAt,
        'createdAt': createdAt?.toIso8601String(),
      };
}
