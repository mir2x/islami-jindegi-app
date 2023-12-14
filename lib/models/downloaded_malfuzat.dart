import 'package:isar/isar.dart';

part 'downloaded_malfuzat.g.dart';

@collection
class DownloadedMalfuzat {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? malfuzatId;

  String? title;

  String? body;

  String? excerpt;

  String? audio;

  String? document;

  String? author;

  String? publishedAt;

  @Index()
  DateTime? createdAt;
}
