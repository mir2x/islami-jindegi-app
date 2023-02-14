import 'package:drift/drift.dart';

class Books extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get price => text().nullable()();
  TextColumn get language => text()();
  TextColumn get imageData => text().nullable()();
  TextColumn get documentData => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get publishedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
