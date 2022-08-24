import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';

part 'news.g.dart';

@JsonSerializable()
@DataRepository([JSONAPIAdapter, ApplicationAdapter])
class News extends DataModel<News> {
  @override
  final String? id;
  final String title;

  News({this.id, required this.title});
}
