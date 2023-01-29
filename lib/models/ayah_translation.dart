import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'ayah.dart';

part 'ayah_translation.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class AyahTranslation extends DataModel<AyahTranslation> {
  @override
  final String? id;
  final String title;
  final String body;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Ayah>? ayah;

  AyahTranslation({
    this.id,
    required this.title,
    required this.body,
    this.createdAt,
    this.updatedAt,
    this.ayah,
  });
}
