import 'package:drift/drift.dart';
import '../types/file_data.dart';

class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get body => text()();

  @JsonKey('image')
  TextColumn get imageData => text().map(const FileData()).nullable()();

  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
