import 'package:drift/drift.dart';

class Surahs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleBn => text()();
  TextColumn get slug => text()();
  TextColumn get excerpt => text().nullable()();
  IntColumn get totalAyat => integer()();
  IntColumn get totalRuku => integer()();
  TextColumn get introduction => text().nullable()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
