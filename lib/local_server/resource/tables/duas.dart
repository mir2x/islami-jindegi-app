import 'package:drift/drift.dart';
import '../types/file_data.dart';

class Duas extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();

  @JsonKey('audio')
  TextColumn get audioData => text().map(const FileData()).nullable()();

  @JsonKey('document')
  TextColumn get documentData => text().map(const FileData()).nullable()();

  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
