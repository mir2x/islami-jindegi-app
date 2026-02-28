import 'dart:convert';

class DuaItem {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final Map<dynamic, dynamic>? audio;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? createdAt;
  final String? updatedAt;

  DuaItem({
    required this.id,
    required this.title,
    required this.body,
    this.excerpt,
    required this.language,
    this.audio,
    this.document,
    this.position,
    this.published,
    this.createdAt,
    this.updatedAt,
  });

  factory DuaItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return DuaItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      body: attrs['body'] ?? '',
      excerpt: attrs['excerpt'],
      language: attrs['language'] ?? 'bn',
      audio: attrs['audio'] is Map ? attrs['audio'] : null,
      document: attrs['document'] is Map ? attrs['document'] : null,
      position: attrs['position'] is int ? attrs['position'] : null,
      published: attrs['published'],
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
    );
  }

  factory DuaItem.fromDb(Map<String, dynamic> row) {
    return DuaItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'] ?? '',
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
      audio: _decodeJson(row['audio_data']),
      document: _decodeJson(row['document_data']),
      position: row['position'] is int ? row['position'] : null,
      published: row['published'] == 1 || row['published'] == true,
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
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
