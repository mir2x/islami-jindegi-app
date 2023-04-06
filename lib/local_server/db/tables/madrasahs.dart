import 'package:drift/drift.dart';
import '../types/file_data.dart';

class Madrasahs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get introduction => text()();
  TextColumn get excerpt => text().nullable()();

  @JsonKey('document')
  TextColumn get documentData => text().map(const FileData()).nullable()();

  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
