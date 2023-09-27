import 'package:drift/drift.dart';

@DataClassName('Country')
class Countries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameBn => text().nullable()();
  TextColumn get code => text()();

  @override
  Set<Column> get primaryKey => {id};
}
