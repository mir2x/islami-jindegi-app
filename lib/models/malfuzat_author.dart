import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_database.dart';

part 'malfuzat_author.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalDatabaseAdapter, ApplicationAdapter])
class MalfuzatAuthor extends DataModel<MalfuzatAuthor> {
  @override
  final String? id;
  final String name;
  final String? info;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  MalfuzatAuthor({
    this.id,
    required this.name,
    this.info,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
