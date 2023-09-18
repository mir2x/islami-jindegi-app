import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';

part 'article_author.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class ArticleAuthor extends DataModel<ArticleAuthor> {
  @override
  final String? id;
  final String name;
  final String? info;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  ArticleAuthor({
    this.id,
    required this.name,
    this.info,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
