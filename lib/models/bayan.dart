import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'speaker.dart';

part 'bayan.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class Bayan extends DataModel<Bayan> {
  @override
  final String? id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final Map<dynamic, dynamic>? audio;
  final bool? published;
  final String publishedAt;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Speaker>? speaker;

  Bayan({
    this.id,
    required this.title,
    this.excerpt,
    required this.language,
    this.location,
    this.audio,
    this.published,
    required this.publishedAt,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.speaker,
  });
}
