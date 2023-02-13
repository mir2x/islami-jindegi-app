import 'package:drift/drift.dart';

class Paras extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleBn => text()();
  TextColumn get slug => text()();
  IntColumn get totalAyat => integer()();
  IntColumn get totalRuku => integer()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
