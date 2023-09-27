import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/local_location.dart';

part 'country.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalLocationAdapter])
class Country extends DataModel<Country> {
  @override
  final String id;
  final String name;
  final String? nameBn;
  final String code;

  Country({
    required this.id,
    required this.name,
    this.nameBn,
    required this.code,
  });
}
