import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'chapter.dart';

part 'subchapter.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Subchapter extends DataModel<Subchapter> {
  @override
  final String? id;
  final String title;
  final String body;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final BelongsTo<Chapter>? chapter;

  Subchapter({
    this.id,
    required this.title,
    required this.body,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.chapter,
  });
}
