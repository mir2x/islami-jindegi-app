import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'quran_book.dart';
import 'para.dart';

part 'quran_book_para.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class QuranBookPara extends DataModel<QuranBookPara> {
  @override
  final String? id;
  final int totalPage;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<QuranBook>? quranBook;
  final BelongsTo<Para>? para;

  QuranBookPara({
    this.id,
    required this.totalPage,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.quranBook,
    this.para,
  });
}
