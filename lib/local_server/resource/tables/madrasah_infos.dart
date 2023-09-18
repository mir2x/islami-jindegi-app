import 'package:drift/drift.dart';
import 'madrasahs.dart';

class MadrasahInfos extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get info => text()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get madrasahId => text().references(Madrasahs, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
