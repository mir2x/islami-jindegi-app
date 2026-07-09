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

  /// From the .NET API's flat AuthorResponse/ArticleAuthorOption JSON
  factory ArticleAuthor.fromJson(Map<String, dynamic> json) {
    return ArticleAuthor(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      info: json['info'],
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory ArticleAuthor.fromDb(Map<String, dynamic> row) {
    return ArticleAuthor(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
