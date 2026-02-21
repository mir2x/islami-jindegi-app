class BookSubchapter {
  final String id;
  final String title;
  final String? body;
  final int? position;
  final String? chapterId;
  final String? createdAt;
  final String? updatedAt;
  // For the subchapter detail screen, we resolve the parent chapter
  final BookSubchapterParentChapter? chapter;

  BookSubchapter({
    required this.id,
    required this.title,
    this.body,
    this.position,
    this.chapterId,
    this.createdAt,
    this.updatedAt,
    this.chapter,
  });

  /// From JSON:API resource
  factory BookSubchapter.fromJsonApi(
    Map<String, dynamic> resource, {
    BookSubchapterParentChapter? resolvedChapter,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return BookSubchapter(
      id: resource['id'].toString(),
      title: attrs['title'] ?? '',
      body: attrs['body'],
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      chapter: resolvedChapter,
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
      createdAt: row['created_at'] ?? row['createdAt'],
      updatedAt: row['updated_at'] ?? row['updatedAt'],
    );
  }
}

/// Lightweight parent chapter reference for subchapter navigation
class BookSubchapterParentChapter {
  final String id;
  final int? position;

  BookSubchapterParentChapter({required this.id, this.position});
}
