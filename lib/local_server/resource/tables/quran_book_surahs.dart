import 'package:drift/drift.dart';
import 'quran_book_pages.dart';
import 'surahs.dart';

class QuranBookSurahs extends Table {
  TextColumn get id => text()();
  IntColumn get startAyah => integer()();
  IntColumn get endAyah => integer()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get quranBookPageId => text().references(QuranBookPages, #id)();
  TextColumn get surahId => text().references(Surahs, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
