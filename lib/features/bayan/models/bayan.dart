/// Pure Dart model for Bayan — no Flutter Data dependency.
class Bayan {
  final String id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final String? audioUrl;
  final bool? published;
  final String publishedAt;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the .NET API's embedded `author` object (Bayan has a
  /// single author via a foreign key — the old Rails "speaker" concept,
  /// unified into the shared Authors table on the .NET side). Kept as
  /// `speakerName` here since that's the bayan-domain-appropriate term the
  /// UI already uses.
  final String? speakerName;

  Bayan({
    required this.id,
    required this.title,
    this.excerpt,
    required this.language,
    this.location,
    this.audioUrl,
    this.published,
    required this.publishedAt,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.speakerName,
  });

  /// Parse from the .NET API's flat BayanListItem/BayanDetail JSON
  factory Bayan.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return Bayan(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      excerpt: json['excerpt'],
      language: json['language'] ?? 'bn',
      location: json['location'],
      audioUrl: json['audioUrl'],
      published: json['published'],
      publishedAt: json['publishedAt'] ?? '',
      position: json['position'] is int ? json['position'] : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      speakerName: author?['name'],
    );
  }

  factory Bayan.fromDb(Map<String, dynamic> row, {String? speakerName}) {
    return Bayan(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
      location: row['location'],
      audioUrl: row['audio_url'] ?? row['audioUrl'],
      published: row['published'] == 1 || row['published'] == true,
      publishedAt: row['published_at'] ?? '',
      position: row['position'] is int ? row['position'] : null,
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
      speakerName: speakerName,
    );
  }
}
