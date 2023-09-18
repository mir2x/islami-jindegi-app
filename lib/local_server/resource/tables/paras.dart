import 'package:drift/drift.dart';

class Paras extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleBn => text()();
  TextColumn get slug => text()();
  IntColumn get totalAyat => integer()();
  IntColumn get totalRuku => integer()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
