import 'package:drift/drift.dart';
import 'quran_books.dart';
import 'paras.dart';

class QuranBookParas extends Table {
  TextColumn get id => text()();
  IntColumn get totalPage => integer()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get quranBookId => text().references(QuranBooks, #id)();
  TextColumn get paraId => text().references(Paras, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
