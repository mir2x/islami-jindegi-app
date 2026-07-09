class ArticleCategory {
  final String id;
  final String title;
  final int? position;

  ArticleCategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From the .NET API's flat CategoryResponse/ArticleCategoryOption JSON
  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory ArticleCategory.fromDb(Map<String, dynamic> row) {
    return ArticleCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
