import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'malfuzat.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Malfuzat extends DataModel<Malfuzat> {
  @override
  final String? id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final bool? hasAudio;
  /* final Map<dynamic, dynamic>? audio; */
  /* final Map<dynamic, dynamic>? document; */
  final int? position;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  Malfuzat({
    this.id,
    required this.title,
    this.body,
    this.excerpt,
    required this.language,
    this.hasAudio,
    /* this.audio, */
    /* this.document, */
    this.position,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });
}
