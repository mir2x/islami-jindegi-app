import 'package:isar/isar.dart';

part 'ayah_bookmark.g.dart';

@collection
class AyahBookmark {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? ayahId;

  String? title;

  String? translation;

  int? position;

  String? surahId;

  String? surahTitle;

  String? surahTitleBn;

  @Index()
  DateTime? createdAt;
}
