import 'package:drift/drift.dart';

class Speakers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get info => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
