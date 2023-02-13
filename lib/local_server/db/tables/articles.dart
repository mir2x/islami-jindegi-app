import 'package:drift/drift.dart';

class Articles extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get body => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();
  TextColumn get documentData => text().nullable()();
  IntColumn get position => integer()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
