import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'bayan_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class BayanCategory extends DataModel<BayanCategory> {
  @override
  final String? id;
  final String title;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  BayanCategory({
    this.id,
    required this.title,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
