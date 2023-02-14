import 'package:drift/drift.dart';

class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get body => text()();
  TextColumn get imageData => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
