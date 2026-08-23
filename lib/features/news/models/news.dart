import '../../../core/navigation/sibling_ref.dart';

/// Pure Dart model for News — no Flutter Data dependency.
class NewsItem {
  final String id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final bool? published;
  final String publishedAt;
  final int? position;
  final String? createdAt;
  final String? updatedAt;
  final SiblingRef? previous;
  final SiblingRef? next;

  NewsItem({
    required this.id,
    required this.title,
    this.body,
    this.excerpt,
    required this.language,
    this.published,
    required this.publishedAt,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.previous,
    this.next,
  });

  /// Parse from the .NET API's flat NewsListItem/NewsDetail JSON.
  /// NewsListItem omits `body` (a detail-only field), so it stays null when
  /// parsing a list response. Neither DTO has an image/document field —
  /// news never carried one on the Flutter side either.
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'],
      excerpt: json['excerpt'],
      language: json['language'] ?? 'bn',
      published: json['published'],
      publishedAt: json['publishedAt'] ?? '',
      position: json['position'] is int ? json['position'] : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      previous: SiblingRef.fromJson(json['previous'] as Map<String, dynamic>?),
      next: SiblingRef.fromJson(json['next'] as Map<String, dynamic>?),
    );
  }
}
