/// Pure Dart model for Masail — no Flutter Data dependency.
class MasailItem {
  final String id;
  final String title;
  final String question;
  final String? answer;
  final String language;
  final bool? hasAudio;
  final Map<dynamic, dynamic>? audio;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the included masail-author relationship
  final String? authorName;

  MasailItem({
    required this.id,
    required this.title,
    required this.question,
    this.answer,
    required this.language,
    this.hasAudio,
    this.audio,
    this.document,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authorName,
  });

  factory MasailItem.fromJsonApi(
    Map<String, dynamic> resource, {
    String? resolvedAuthorName,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MasailItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      question: attrs['question'] ?? '',
      answer: attrs['answer'],
      language: attrs['language'] ?? 'bn',
      hasAudio: attrs['has-audio'],
      audio: attrs['audio'] is Map ? attrs['audio'] : null,
      document: attrs['document'] is Map ? attrs['document'] : null,
      position: attrs['position'] is int ? attrs['position'] : null,
      published: attrs['published'],
      publishedAt: attrs['published-at'],
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      authorName: resolvedAuthorName,
    );
  }
}
