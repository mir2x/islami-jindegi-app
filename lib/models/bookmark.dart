import 'package:isar_community/isar.dart';

part 'bookmark.g.dart';

@collection
class Bookmark {
  Id id = Isar.autoIncrement;

  @Index()
  String? type;

  String? title;

  @Index(unique: true, replace: true)
  String? link;

  @Index()
  DateTime? createdAt;
}
