import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'madrasah.dart';

part 'madrasah_photo.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class MadrasahPhoto extends DataModel<MadrasahPhoto> {
  @override
  final String? id;
  final String? title;
  final Map<dynamic, dynamic>? image;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Madrasah>? madrasah;

  MadrasahPhoto({
    this.id,
    this.title,
    this.image,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.madrasah,
  });
}
