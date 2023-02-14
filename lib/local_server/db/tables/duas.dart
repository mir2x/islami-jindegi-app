import 'package:drift/drift.dart';

class Duas extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();
  TextColumn get audioData => text().nullable()();
  TextColumn get documentData => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
