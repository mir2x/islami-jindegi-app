import 'package:drift/drift.dart';
import 'books.dart';
import 'authors.dart';

class BooksAuthors extends Table {
  TextColumn get id => text()();

  TextColumn get bookId => text().references(Books, #id)();
  TextColumn get authorId => text().references(Authors, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
