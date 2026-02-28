import 'dart:convert';

/// Pure Dart model for Bayan — no Flutter Data dependency.
class Bayan {
  final String id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final Map<dynamic, dynamic>? audio;
  final bool? published;
  final String publishedAt;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the included speaker relationship
  final String? speakerName;

  Bayan({
    required this.id,
    required this.title,
    this.excerpt,
    required this.language,
    this.location,
    this.audio,
    this.published,
    required this.publishedAt,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.speakerName,
  });

  factory Bayan.fromJsonApi(
    Map<String, dynamic> resource, {
    String? resolvedSpeakerName,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return Bayan(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      excerpt: attrs['excerpt'],
      language: attrs['language'] ?? 'bn',
      location: attrs['location'],
      audio: attrs['audio'] is Map ? attrs['audio'] : null,
      published: attrs['published'],
      publishedAt: attrs['published-at'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      speakerName: resolvedSpeakerName,
    );
  }

  factory Bayan.fromDb(Map<String, dynamic> row, {String? speakerName}) {
    return Bayan(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
      location: row['location'],
      audio: _decodeJson(row['audio_data']),
      published: row['published'] == 1 || row['published'] == true,
      publishedAt: row['published_at'] ?? '',
      position: row['position'] is int ? row['position'] : null,
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
      speakerName: speakerName,
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
