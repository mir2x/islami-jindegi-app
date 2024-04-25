import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';

part 'para.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class Para extends DataModel<Para> {
  @override
  final String? id;
  final String title;
  final String titleBn;
  final String? searchTitle;
  final String slug;
  final int totalAyat;
  final int totalRuku;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  Para({
    this.id,
    required this.title,
    required this.titleBn,
    this.searchTitle,
    required this.slug,
    required this.totalAyat,
    required this.totalRuku,
    this.position,
    this.createdAt,
    this.updatedAt,
  });
}
