import 'package:drift/drift.dart';

@DataClassName('DuaCategory')
class DuaCategories extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
