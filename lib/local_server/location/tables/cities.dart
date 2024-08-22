import 'package:drift/drift.dart';

@DataClassName('City')
class Cities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameBn => text().nullable()();
  TextColumn get countryCode => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get timezone => text()();

  @override
  Set<Column> get primaryKey => {id};
}
