import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_database.dart';
import 'speaker.dart';

part 'bayan.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalDatabaseAdapter, ApplicationAdapter])
class Bayan extends DataModel<Bayan> {
  @override
  final String? id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final Map<dynamic, dynamic>? audio;
  final String publishedAt;
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
    required this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.speaker,
  });
}
