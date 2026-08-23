import 'book_subchapter.dart';
import 'book_node_ref.dart';

class BookChapter {
  final String id;
  final String title;
  final String? body;
  final int? position;
  final String? bookId;
  final int? readingOrder;
  final BookNodeRef? previous;
  final BookNodeRef? next;
  final bool isOffline;
  final List<BookSubchapter> subchapters;

  BookChapter({
    required this.id,
    required this.title,
    this.body,
    this.position,
    this.bookId,
    this.readingOrder,
    this.previous,
    this.next,
    this.isOffline = false,
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
      readingOrder: json['readingOrder'] as int?,
      previous: BookNodeRef.fromJson(json['previous'] as Map<String, dynamic>?),
      next: BookNodeRef.fromJson(json['next'] as Map<String, dynamic>?),
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
      readingOrder: row['reading_order'] as int?,
      subchapters: subchapters,
      isOffline: true,
    );
  }
}
