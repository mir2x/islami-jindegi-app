import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'article_category.dart';

part 'article_subcategory.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class ArticleSubcategory extends DataModel<ArticleSubcategory> {
  @override
  final String? id;
  final String title;
  final String slug;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<ArticleCategory>? articleCategory;

  ArticleSubcategory({
    this.id,
    required this.title,
    required this.slug,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.articleCategory,
  });
}
