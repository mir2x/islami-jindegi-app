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
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
