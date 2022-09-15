import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'article.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Article extends DataModel<Article> {
  @override
  final String? id;
  final String title;
  final String slug;
  final String body;
  final String? excerpt;
  final String language;
  final Map? document;
  final int? position;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  Article({
    this.id,
    required this.title,
    required this.slug,
    required this.body,
    this.excerpt,
    required this.language,
    this.document,
    this.position,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });
}
