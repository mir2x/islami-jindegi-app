/// Pure Dart model for Article — no Flutter Data dependency.
class ArticleItem {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the included article-author relationship
  final String? authorName;

  ArticleItem({
    required this.id,
    required this.title,
    required this.body,
    this.excerpt,
    required this.language,
    this.document,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authorName,
  });

  factory ArticleItem.fromJsonApi(
    Map<String, dynamic> resource, {
    String? resolvedAuthorName,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return ArticleItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      body: attrs['body'] ?? '',
      excerpt: attrs['excerpt'],
      language: attrs['language'] ?? 'bn',
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
