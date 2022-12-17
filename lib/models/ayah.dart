import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'surah.dart';
import 'para.dart';

part 'ayah.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Ayah extends DataModel<Ayah> {
  @override
  final String? id;
  final String title;
  final int? surahPosition;
  final int? paraPosition;
  final int? ruku;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Surah>? surah;
  final BelongsTo<Para>? para;

  Ayah({
    this.id,
    required this.title,
    this.surahPosition,
    this.paraPosition,
    this.ruku,
    this.createdAt,
    this.updatedAt,
    this.surah,
    this.para,
  });
}
