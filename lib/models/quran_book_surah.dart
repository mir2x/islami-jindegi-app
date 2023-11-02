import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'quran_book_page.dart';
import 'surah.dart';

part 'quran_book_surah.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class QuranBookSurah extends DataModel<QuranBookSurah> {
  @override
  final String? id;
  final int startAyah;
  final int endAyah;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<QuranBookPage>? quranBookPage;
  final BelongsTo<Surah>? surah;

  QuranBookSurah({
    this.id,
    required this.startAyah,
    required this.endAyah,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.quranBookPage,
    this.surah,
  });
}
