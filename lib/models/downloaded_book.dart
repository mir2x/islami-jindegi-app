import 'package:isar/isar.dart';

part 'downloaded_book.g.dart';

@collection
class DownloadedBook {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? bookId;

  String? title;

  String? author;

  String? documentFile;

  @Index(unique: true, replace: true)
  String? link;

  @Index()
  DateTime? createdAt;
}
