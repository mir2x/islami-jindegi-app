import 'dua_category.dart';

/// Pure Dart model for Dua — no Flutter Data dependency.
///
/// Dua has no author concept (unlike book/article/malfuzat/masail) — only a
/// flat category. It also has no server-side `hasAudio` flag (unlike
/// malfuzat/masail): presence of audio is inferred from `audioUrl` being
/// non-null.
class DuaItem {
  final String id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final String? audioUrl;
  final String? documentUrl;
  final int? position;
  final bool? published;
  final String? createdAt;
  final String? updatedAt;
  final List<DuaCategory> categories;

  DuaItem({
    required this.id,
    required this.title,
    this.body,
    this.excerpt,
    required this.language,
    this.audioUrl,
    this.documentUrl,
    this.position,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.categories = const [],
  });

  /// Parse from the .NET API's flat DuaListItem/DuaDetail JSON.
  /// DuaListItem omits `body`/`documentUrl` (detail-only fields), so those
  /// stay null when parsing a list response.
  factory DuaItem.fromJson(Map<String, dynamic> json) {
    return DuaItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'],
      excerpt: json['excerpt'],
      language: json['language'] ?? 'bn',
      audioUrl: json['audioUrl'],
      documentUrl: json['documentUrl'],
      position: json['position'] is int ? json['position'] : null,
      published: json['published'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      categories: (json['categories'] as List? ?? [])
          .map((c) => DuaCategory.fromJson(c))
          .toList(),
    );
  }

  factory DuaItem.fromDb(Map<String, dynamic> row) {
    return DuaItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'],
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
      audioUrl: row['audio_url'] ?? row['audioUrl'],
      documentUrl: row['document_url'] ?? row['documentUrl'],
      position: row['position'] is int ? row['position'] : null,
      published: row['published'] == 1 || row['published'] == true,
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
    );
  }
}
