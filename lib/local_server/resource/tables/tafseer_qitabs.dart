import 'package:drift/drift.dart';

class TafseerQitabs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text()();

  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
