import 'package:drift/drift.dart';

@DataClassName('City')
class Cities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get countryCode => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  @override
  Set<Column> get primaryKey => {id};
}
