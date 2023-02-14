import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_database.dart';

part 'namaz_time.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalDatabaseAdapter, ApplicationAdapter])
class NamazTime extends DataModel<NamazTime> {
  @override
  final String? id;
  final String title;
  final String slug;
  final String masail;
  final String? fazail;
  final String? createdAt;
  final String? updatedAt;

  NamazTime({
    this.id,
    required this.title,
    required this.slug,
    required this.masail,
    this.fazail,
    this.createdAt,
    this.updatedAt,
  });
}
