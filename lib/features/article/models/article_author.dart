/// Pure Dart model for ArticleAuthor.
class ArticleAuthor {
  final String id;
  final String name;
  final String? info;
  final int? position;

  ArticleAuthor({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  factory ArticleAuthor.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return ArticleAuthor(
      id: resource['id']?.toString() ?? '',
      name: attrs['name'] ?? '',
      info: attrs['info'],
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }
}
