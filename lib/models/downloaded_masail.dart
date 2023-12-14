import 'package:isar/isar.dart';

part 'downloaded_masail.g.dart';

@collection
class DownloadedMasail {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? masailId;

  String? title;

  String? question;

  String? answer;

  String? audio;

  String? document;

  String? author;

  String? publishedAt;

  @Index()
  DateTime? createdAt;
}
