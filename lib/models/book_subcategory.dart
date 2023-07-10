import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'book_category.dart';

part 'book_subcategory.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class BookSubcategory extends DataModel<BookSubcategory> {
  @override
  final String? id;
  final String title;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<BookCategory>? bookCategory;

  BookSubcategory({
    this.id,
    required this.title,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.bookCategory,
  });
}
