enum BookNodeKind { chapter, subchapter }

class BookReadingProgress {
  const BookReadingProgress({
    required this.bookId,
    required this.bookTitle,
    this.nodeId,
    this.nodeTitle,
    this.nodeKind,
    required this.updatedAt,
  });

  final String bookId;

  /// Display cache only. Navigation always uses the stable IDs above/below.
  final String bookTitle;
  final String? nodeId;
  final String? nodeTitle;
  final BookNodeKind? nodeKind;
  final DateTime updatedAt;

  factory BookReadingProgress.fromJson(
    String bookId,
    Map<String, dynamic> json,
  ) {
    final kind = switch (json['nodeKind']) {
      'chapter' => BookNodeKind.chapter,
      'subchapter' => BookNodeKind.subchapter,
      _ => null,
    };
    return BookReadingProgress(
      bookId: bookId,
      bookTitle: json['bookTitle'] as String? ?? '',
      nodeId: json['nodeId'] as String?,
      nodeTitle: json['nodeTitle'] as String?,
      nodeKind: kind,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
        'bookTitle': bookTitle,
        if (nodeId != null) 'nodeId': nodeId,
        if (nodeTitle != null) 'nodeTitle': nodeTitle,
        if (nodeKind != null) 'nodeKind': nodeKind!.name,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };
}
