import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'tafseer_qitab.dart';
import 'ayah.dart';

part 'tafseer.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class Tafseer extends DataModel<Tafseer> {
  @override
  final String? id;
  final String body;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<TafseerQitab>? tafseerQitab;
  final BelongsTo<Ayah>? ayah;

  Tafseer({
    this.id,
    required this.body,
    this.createdAt,
    this.updatedAt,
    this.tafseerQitab,
    this.ayah,
  });
}
