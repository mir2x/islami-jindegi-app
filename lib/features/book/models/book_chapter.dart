import 'book_subchapter.dart';

class BookChapter {
  final String id;
  final String title;
  final String? body;
  final int? position;
  final String? bookId;
  final String? createdAt;
  final String? updatedAt;
  final List<BookSubchapter> subchapters;

  BookChapter({
    required this.id,
    required this.title,
    this.body,
    this.position,
    this.bookId,
    this.createdAt,
    this.updatedAt,
    this.subchapters = const [],
  });

  /// From JSON:API resource + resolved included subchapters
  factory BookChapter.fromJsonApi(
    Map<String, dynamic> resource, {
    List<BookSubchapter> resolvedSubchapters = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return BookChapter(
      id: resource['id'].toString(),
      title: attrs['title'] ?? '',
      body: attrs['body'],
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      subchapters: resolvedSubchapters,
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
      createdAt: row['created_at'] ?? row['createdAt'],
      updatedAt: row['updated_at'] ?? row['updatedAt'],
      subchapters: subchapters,
    );
  }
}
