import 'package:drift/drift.dart';
import 'masail_authors.dart';
import '../types/file_data.dart';

class Masails extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get question => text()();
  TextColumn get answer => text().nullable()();
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

  TextColumn get masailAuthorId => text().references(MasailAuthors, #id).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
