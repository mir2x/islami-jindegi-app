import 'dart:convert';

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

  factory ArticleItem.fromDb(
    Map<String, dynamic> row, {
    String? authorName,
  }) {
    return ArticleItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'] ?? '',
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
      document: _decodeJson(row['document_data']),
      position: row['position'] is int ? row['position'] : null,
      published: row['published'] == 1 || row['published'] == true,
      publishedAt: row['published_at'],
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
      authorName: authorName,
    );
  }

  static Map<dynamic, dynamic>? _decodeJson(dynamic value) {
    if (value == null) return null;
    if (value is Map) return value;
    if (value is String) {
      try {
        return json.decode(value) as Map;
      } catch (_) {}
    }
    return null;
  }
}
