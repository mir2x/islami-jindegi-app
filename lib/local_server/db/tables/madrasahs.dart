import 'package:drift/drift.dart';

class Madrasahs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get introduction => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get documentData => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
