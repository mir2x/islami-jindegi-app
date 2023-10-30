import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'setting.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class Setting extends DataModel<Setting> {
  @override
  final String? id;
  final bool askQuestion;
  final String? createdAt;
  final String? updatedAt;

  Setting({
    this.id,
    required this.askQuestion,
    this.createdAt,
    this.updatedAt,
  });
}
