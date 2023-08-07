import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_database.dart';

part 'news.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalDatabaseAdapter, ApplicationAdapter])
class News extends DataModel<News> {
  @override
  final String? id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final bool? published;
  final String publishedAt;
  final String? createdAt;
  final String? updatedAt;

  News({
    this.id,
    required this.title,
    required this.body,
    this.excerpt,
    required this.language,
    this.published,
    required this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });
}
