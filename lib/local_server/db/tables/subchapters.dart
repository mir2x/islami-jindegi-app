import 'package:drift/drift.dart';
import 'chapters.dart';

class Subchapters extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get chapterId => text().references(Chapters, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
