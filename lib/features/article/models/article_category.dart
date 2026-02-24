import 'article_subcategory.dart';

/// Pure Dart model for ArticleCategory with resolved subcategories.
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
}
