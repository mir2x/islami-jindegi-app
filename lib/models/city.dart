import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/local_location.dart';

part 'city.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalLocationAdapter])
class City extends DataModel<City> {
  @override
  final String id;
  final String name;
  final String countryCode;
  final String countryName;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });
}
