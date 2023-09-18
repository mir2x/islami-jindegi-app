import 'package:drift/drift.dart';
import 'speakers.dart';
import '../types/file_data.dart';

class Bayans extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();
  TextColumn get location => text().nullable()();

  @JsonKey('audio')
  TextColumn get audioData => text().map(const FileData()).nullable()();

  IntColumn get position => integer()();
  TextColumn get publishedAt => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get speakerId => text().references(Speakers, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
