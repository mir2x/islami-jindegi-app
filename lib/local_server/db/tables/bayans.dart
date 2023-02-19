import 'package:drift/drift.dart';
import 'speakers.dart';

class Bayans extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();
  TextColumn get location => text().nullable()();
  TextColumn get audioData => text().nullable()();
  TextColumn get publishedAt => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get speakerId => text().references(Speakers, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
