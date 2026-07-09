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
    );
  }
}
