import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'quran_book.dart';

part 'quran_book_qitab.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class QuranBookQitab extends DataModel<QuranBookQitab> {
  @override
  final String? id;
  final String title;
  final String? titleBn;
  final Map<dynamic, dynamic>? image;
  final Map<dynamic, dynamic>? document;
  final bool published;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<QuranBook>? quranBook;

  QuranBookQitab({
    this.id,
    required this.title,
    this.titleBn,
    this.image,
    this.document,
    required this.published,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.quranBook,
  });
}
