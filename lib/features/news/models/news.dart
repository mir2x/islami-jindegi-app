/// Pure Dart model for News — no Flutter Data dependency.
class NewsItem {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final bool? published;
  final String publishedAt;
  final String? createdAt;
  final String? updatedAt;

  NewsItem({
    required this.id,
    required this.title,
    required this.body,
    this.excerpt,
    required this.language,
    this.published,
    required this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return NewsItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      body: attrs['body'] ?? '',
      excerpt: attrs['excerpt'],
      language: attrs['language'] ?? 'bn',
      published: attrs['published'],
      publishedAt: attrs['published-at'] ?? '',
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
    );
  }
}
