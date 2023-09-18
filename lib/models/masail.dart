import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'masail_author.dart';

part 'masail.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class Masail extends DataModel<Masail> {
  @override
  final String? id;
  final String title;
  final String question;
  final String? answer;
  final String language;
  final bool? hasAudio;
  final Map<dynamic, dynamic>? audio;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<MasailAuthor>? masailAuthor;

  Masail({
    this.id,
    required this.title,
    required this.question,
    this.answer,
    required this.language,
    this.hasAudio,
    this.audio,
    this.document,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.masailAuthor,
  });
}
