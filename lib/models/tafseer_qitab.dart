import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'package:native_app/adapters/application.dart';

part 'tafseer_qitab.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class TafseerQitab extends DataModel<TafseerQitab> {
  @override
  final String? id;
  final String title;
  final String author;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  TafseerQitab({
    this.id,
    required this.title,
    required this.author,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
