import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_database.dart';
import 'madrasah_info.dart';
import 'madrasah_photo.dart';

part 'madrasah.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalDatabaseAdapter, ApplicationAdapter])
class Madrasah extends DataModel<Madrasah> {
  @override
  final String? id;
  final String title;
  final String introduction;
  final String? excerpt;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final HasMany<MadrasahInfo>? madrasahInfos;
  final HasMany<MadrasahPhoto>? madrasahPhotos;

  Madrasah({
    this.id,
    required this.title,
    required this.introduction,
    this.excerpt,
    this.document,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.madrasahInfos,
    this.madrasahPhotos,
  });
}
