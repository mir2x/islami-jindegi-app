import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'madrasah.dart';

part 'madrasah_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class MadrasahInfo extends DataModel<MadrasahInfo> {
  @override
  final String? id;
  final String label;
  final String info;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Madrasah>? madrasah;

  MadrasahInfo({
    this.id,
    required this.label,
    required this.info,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.madrasah,
  });
}
