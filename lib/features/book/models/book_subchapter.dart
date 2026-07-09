class BookSubchapter {
  final String id;
  final String title;
  final String? body;
  final int? position;
  final String? chapterId;
  final String? chapterTitle;
  final String? parentSubChapterId;

  BookSubchapter({
    required this.id,
    required this.title,
    this.body,
    this.position,
    this.chapterId,
    this.chapterTitle,
    this.parentSubChapterId,
  });

  /// From the .NET API's flat SubChapterResponse/SubChapterDetail JSON
  factory BookSubchapter.fromJson(Map<String, dynamic> json) {
    return BookSubchapter(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'],
      position: json['position'] is int ? json['position'] : null,
      chapterId: json['chapterId']?.toString(),
      chapterTitle: json['chapterTitle'],
      parentSubChapterId: json['parentSubChapterId']?.toString(),
    );
  }

  /// From local SQLite row
  factory BookSubchapter.fromDb(Map<String, dynamic> row) {
    return BookSubchapter(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'],
      position: row['position'] is int ? row['position'] : null,
      chapterId: row['chapter_id']?.toString() ?? row['chapterId']?.toString(),
    );
  }
}
