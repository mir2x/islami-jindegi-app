class ArticleSubcategory {
  final String id;
  final String title;
  final int? position;

  ArticleSubcategory({
    required this.id,
    required this.title,
    this.position,
  });

  factory ArticleSubcategory.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return ArticleSubcategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }

  factory ArticleSubcategory.fromDb(Map<String, dynamic> row) {
    return ArticleSubcategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
