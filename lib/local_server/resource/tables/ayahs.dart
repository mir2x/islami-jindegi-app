import 'package:drift/drift.dart';
import 'surahs.dart';
import 'paras.dart';

class Ayahs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get surahPosition => integer()();
  IntColumn get paraPosition => integer()();
  IntColumn get ruku => integer().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get surahId => text().references(Surahs, #id)();
  TextColumn get paraId => text().references(Paras, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
