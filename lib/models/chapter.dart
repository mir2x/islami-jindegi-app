import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'book.dart';

part 'chapter.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Chapter extends DataModel<Chapter> {
  @override
  final String? id;
  final String title;
  final String? body;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Book>? book;

  Chapter({
    this.id,
    required this.title,
    this.body,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.book,
  });
}
