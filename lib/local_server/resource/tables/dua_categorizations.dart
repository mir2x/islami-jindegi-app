import 'package:drift/drift.dart';
import 'duas.dart';
import 'dua_categories.dart';

class DuaCategorizations extends Table {
  TextColumn get id => text()();

  TextColumn get duaId => text().references(Duas, #id)();
  TextColumn get duaCategoryId => text().references(DuaCategories, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
