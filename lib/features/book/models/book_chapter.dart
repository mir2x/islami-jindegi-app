import 'book_subchapter.dart';

class BookChapter {
  final String id;
  final String title;
  final String? body;
  final int? position;
  final String? bookId;
  final List<BookSubchapter> subchapters;

  BookChapter({
    required this.id,
    required this.title,
    this.body,
    this.position,
    this.bookId,
    this.subchapters = const [],
  });

  /// From the .NET API's flat ChapterResponse/ChapterDetail JSON
  factory BookChapter.fromJson(Map<String, dynamic> json) {
    return BookChapter(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'],
      position: json['position'] is int ? json['position'] : null,
      bookId: json['bookId']?.toString(),
      subchapters: (json['subChapters'] as List? ?? [])
          .map((s) => BookSubchapter.fromJson(s))
          .toList(),
    );
  }

  /// From local SQLite row + pre-joined subchapters
  factory BookChapter.fromDb(
    Map<String, dynamic> row, {
    List<BookSubchapter> subchapters = const [],
  }) {
    return BookChapter(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'],
      position: row['position'] is int ? row['position'] : null,
      bookId: row['book_id']?.toString() ?? row['bookId']?.toString(),
      subchapters: subchapters,
    );
  }
}
