import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'madrasah.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
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

  Madrasah({
    this.id,
    required this.title,
    required this.introduction,
    this.excerpt,
    this.document,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
