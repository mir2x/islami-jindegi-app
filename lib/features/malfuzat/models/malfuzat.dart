/// Pure Dart model for Malfuzat — no Flutter Data dependency.
class MalfuzatItem {
  final String id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final bool? hasAudio;
  final Map<dynamic, dynamic>? audio;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the included malfuzat-author relationship
  final String? authorName;

  MalfuzatItem({
    required this.id,
    required this.title,
    this.body,
    this.excerpt,
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

  factory MalfuzatItem.fromJsonApi(
    Map<String, dynamic> resource, {
    String? resolvedAuthorName,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MalfuzatItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      body: attrs['body'],
      excerpt: attrs['excerpt'],
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
