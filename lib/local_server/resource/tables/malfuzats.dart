import 'package:drift/drift.dart';
import 'malfuzat_authors.dart';
import '../types/file_data.dart';

class Malfuzats extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();
  BoolColumn get hasAudio => boolean().withDefault(const Constant(false))();

  @JsonKey('audio')
  TextColumn get audioData => text().map(const FileData()).nullable()();

  @JsonKey('document')
  TextColumn get documentData => text().map(const FileData()).nullable()();

  IntColumn get position => integer()();
  TextColumn get publishedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get malfuzatAuthorId => text().references(MalfuzatAuthors, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
