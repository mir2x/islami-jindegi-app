import 'package:drift/drift.dart';
import 'books.dart';

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get bookId => text().references(Books, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
