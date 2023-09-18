import 'package:drift/drift.dart';

class Surahs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleBn => text()();
  TextColumn get slug => text()();
  TextColumn get introduction => text().nullable()();
  TextColumn get excerpt => text().nullable()();
  IntColumn get totalAyat => integer()();
  IntColumn get totalRuku => integer()();
  TextColumn get location => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
