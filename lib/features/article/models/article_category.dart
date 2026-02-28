import 'article_subcategory.dart';

class ArticleCategory {
  final String id;
  final String title;
  final int? position;
  final List<ArticleSubcategory> articleSubcategories;

  ArticleCategory({
    required this.id,
    required this.title,
    this.position,
    this.articleSubcategories = const [],
  });

  factory ArticleCategory.fromJsonApi(
    Map<String, dynamic> resource, {
    List<ArticleSubcategory> resolvedSubcategories = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return ArticleCategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      articleSubcategories: resolvedSubcategories,
    );
  }

  factory ArticleCategory.fromDb(
    Map<String, dynamic> row, {
    List<ArticleSubcategory> subcategories = const [],
  }) {
    return ArticleCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
      articleSubcategories: subcategories,
    );
  }
}
