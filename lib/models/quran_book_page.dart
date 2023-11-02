import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'quran_book.dart';
import 'para.dart';

part 'quran_book_page.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class QuranBookPage extends DataModel<QuranBookPage> {
  @override
  final String? id;
  final String title;
  final int paraPage;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<QuranBook>? quranBook;
  final BelongsTo<Para>? para;

  QuranBookPage({
    this.id,
    required this.title,
    required this.paraPage,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.quranBook,
    this.para,
  });
}
