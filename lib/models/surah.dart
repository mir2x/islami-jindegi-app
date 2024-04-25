import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_resource.dart';
import 'ayah.dart';

part 'surah.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalResourceAdapter, ApplicationAdapter])
class Surah extends DataModel<Surah> {
  @override
  final String? id;
  final String title;
  final String titleBn;
  final String? searchTitle;
  final String slug;
  final String? introduction;
  final String? excerpt;
  final int totalAyat;
  final int totalRuku;
  final String? location;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  final HasMany<Ayah>? ayahs;

  Surah({
    this.id,
    required this.title,
    required this.titleBn,
    this.searchTitle,
    required this.slug,
    this.introduction,
    this.excerpt,
    required this.totalAyat,
    required this.totalRuku,
    this.location,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.ayahs,
  });
}
