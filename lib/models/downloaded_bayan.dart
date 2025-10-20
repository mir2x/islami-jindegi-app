import 'package:isar_community/isar.dart';

part 'downloaded_bayan.g.dart';

@collection
class DownloadedBayan {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? bayanId;

  String? title;

  String? excerpt;

  String? location;

  String? audio;

  String? speaker;

  String? publishedAt;

  @Index()
  DateTime? createdAt;
}
