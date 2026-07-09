class ArticleItem {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final String? documentUrl;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? authorName;

  ArticleItem({
    required this.id,
    required this.title,
    required this.body,
    this.excerpt,
    required this.language,
    this.documentUrl,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authorName,
  });

  /// Parse from the .NET API's flat ArticleListItem/ArticleDetail JSON
  factory ArticleItem.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return ArticleItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      excerpt: json['excerpt'],
      language: json['language'] ?? 'bn',
      documentUrl: json['documentUrl'],
      position: json['position'] is int ? json['position'] : null,
      published: json['published'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      authorName: author?['name'],
    );
  }

  factory ArticleItem.fromDb(
    Map<String, dynamic> row, {
    String? authorName,
  }) {
    return ArticleItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      body: row['body'] ?? '',
      excerpt: row['excerpt'],
      language: row['language'] ?? 'bn',
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
