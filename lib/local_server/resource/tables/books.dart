import 'package:drift/drift.dart';
import '../types/file_data.dart';

class Books extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get price => text().nullable()();
  TextColumn get language => text()();

  @JsonKey('image')
  TextColumn get imageData => text().map(const FileData()).nullable()();

  @JsonKey('document')
  TextColumn get documentData => text().map(const FileData()).nullable()();

  IntColumn get position => integer()();
  TextColumn get publishedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
