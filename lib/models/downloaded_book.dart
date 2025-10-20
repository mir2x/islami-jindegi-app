import 'package:isar_community/isar.dart';

part 'downloaded_book.g.dart';

@collection
class DownloadedBook {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? bookId;

  String? title;

  String? excerpt;

  String? publisher;

  String? price;

  String? image;

  String? document;

  String? authors;

  String? publishedAt;

  @Index()
  DateTime? createdAt;
}
