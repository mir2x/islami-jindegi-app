import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'dua.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Dua extends DataModel<Dua> {
  @override
  final String? id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final Map<dynamic, dynamic>? audio;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  Dua({
    this.id,
    required this.title,
    required this.body,
    this.excerpt,
    required this.language,
    this.audio,
    this.document,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
