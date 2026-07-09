import 'masail_category.dart';

/// Pure Dart model for Masail — no Flutter Data dependency.
class MasailItem {
  final String id;
  final String title;
  final String? question;
  final String? answer;
  final String language;
  final bool? hasAudio;
  final String? audioUrl;
  final String? documentUrl;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<MasailCategory> categories;

  /// Resolved from the .NET API's flat `author` relationship
  final String? authorName;

  MasailItem({
    required this.id,
    required this.title,
    this.question,
    this.answer,
    required this.language,
    this.hasAudio,
    this.audioUrl,
    this.documentUrl,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.categories = const [],
    this.authorName,
  });

  /// Parse from the .NET API's flat MasailListItem/MasailDetail JSON.
  /// MasailListItem omits `question`/`answer`/`documentUrl` (detail-only
  /// fields), so those stay null when parsing a list response.
  factory MasailItem.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return MasailItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      question: json['question'],
      answer: json['answer'],
      language: json['language'] ?? 'bn',
      hasAudio: json['hasAudio'],
      audioUrl: json['audioUrl'],
      documentUrl: json['documentUrl'],
      position: json['position'] is int ? json['position'] : null,
      published: json['published'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      categories: (json['categories'] as List? ?? [])
          .map((c) => MasailCategory.fromJson(c))
          .toList(),
      authorName: author?['name'],
    );
  }

  factory MasailItem.fromDb(Map<String, dynamic> row, {String? authorName}) {
    return MasailItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      question: row['question'],
      answer: row['answer'],
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
