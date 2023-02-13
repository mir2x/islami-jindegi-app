import 'package:drift/drift.dart';

class Masails extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get question => text()();
  TextColumn get answer => text().nullable()();
  TextColumn get language => text()();
  BoolColumn get hasAudio => boolean().withDefault(const Constant(false))();
  TextColumn get audioData => text().nullable()();
  TextColumn get documentData => text().nullable()();
  IntColumn get position => integer()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
