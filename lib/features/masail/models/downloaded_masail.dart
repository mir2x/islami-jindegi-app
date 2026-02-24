/// Pure Dart model for DownloadedMasail — stored locally via SharedPreferences.
class DownloadedMasail {
  int id;
  String? masailId;
  String? title;
  String? question;
  String? answer;
  String? audio;
  String? document;
  String? author;
  String? publishedAt;
  DateTime? createdAt;

  DownloadedMasail({
    this.id = 0,
    this.masailId,
    this.title,
    this.question,
    this.answer,
    this.audio,
    this.document,
    this.author,
    this.publishedAt,
    this.createdAt,
  });

  factory DownloadedMasail.fromJson(Map<String, dynamic> json) {
    return DownloadedMasail(
      id: json['id'] ?? 0,
      masailId: json['masailId'],
      title: json['title'],
      question: json['question'],
      answer: json['answer'],
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
        'masailId': masailId,
        'title': title,
        'question': question,
        'answer': answer,
        'audio': audio,
        'document': document,
        'author': author,
        'publishedAt': publishedAt,
        'createdAt': createdAt?.toIso8601String(),
      };
}
