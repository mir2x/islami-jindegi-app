import 'package:drift/drift.dart';
import 'chapters.dart';

class Subchapters extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get chapterId => text().references(Chapters, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
