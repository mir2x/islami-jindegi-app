import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'hijri_adjustment.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class HijriAdjustment extends DataModel<HijriAdjustment> {
  @override
  final String? id;
  final String country;
  final String countryCode;
  final int adjustment;
  final String? createdAt;
  final String? updatedAt;

  HijriAdjustment({
    this.id,
    required this.country,
    required this.countryCode,
    required this.adjustment,
    this.createdAt,
    this.updatedAt,
  });
}
