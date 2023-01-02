import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'book_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class BookCategory extends DataModel<BookCategory> {
  @override
  final String? id;
  final String title;
  final String slug;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  BookCategory({
    this.id,
    required this.title,
    required this.slug,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
