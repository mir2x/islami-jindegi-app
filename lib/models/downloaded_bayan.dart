import 'package:isar/isar.dart';

part 'downloaded_bayan.g.dart';

@collection
class DownloadedBayan {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? bayanId;

  String? title;

  String? speaker;

  String? audioFile;

  String? publishedAt;

  @Index(unique: true, replace: true)
  String? link;

  @Index()
  DateTime? createdAt;
}
