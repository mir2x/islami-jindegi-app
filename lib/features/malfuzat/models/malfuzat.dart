/// Pure Dart model for Malfuzat — no Flutter Data dependency.
class MalfuzatItem {
  final String id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final bool? hasAudio;
  final String? audioUrl;
  final String? documentUrl;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the .NET API's embedded `author` object (Malfuzat has a
  /// single author via a foreign key, unlike Book's many-to-many authors).
  final String? authorName;

  MalfuzatItem({
    required this.id,
    required this.title,
    this.body,
    this.excerpt,
    required this.language,
    this.hasAudio,
    this.audioUrl,
    this.documentUrl,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authorName,
  });

  /// Parse from the .NET API's flat MalfuzatListItem/MalfuzatDetail JSON
  factory MalfuzatItem.fromJson(Map<String, dynamic> json) {
    return MalfuzatItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'],
      excerpt: json['excerpt'],
      language: json['language'] ?? 'bn',
      hasAudio: json['hasAudio'],
      audioUrl: json['audioUrl'],
      documentUrl: json['documentUrl'],
      position: json['position'] is int ? json['position'] : null,
      published: json['published'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      authorName: json['author'] is Map ? json['author']['name'] : null,
    );
  }

  factory MalfuzatItem.fromDb(Map<String, dynamic> row, {String? authorName}) {
    return MalfuzatItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'],
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
      hasAudio: row['has_audio'] == 1 || row['has_audio'] == true,
      audioUrl: row['audio_url'] ?? row['audioUrl'],
      documentUrl: row['document_url'] ?? row['documentUrl'],
      position: row['position'] is int ? row['position'] : null,
      published: row['published'] == 1 || row['published'] == true,
      publishedAt: row['published_at'],
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
      authorName: authorName,
    );
  }
}
