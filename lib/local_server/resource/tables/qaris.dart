import 'package:drift/drift.dart';

class Qaris extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameBn => text().nullable()();
  TextColumn get slug => text()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
