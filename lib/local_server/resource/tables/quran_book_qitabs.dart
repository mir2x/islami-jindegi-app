import 'package:drift/drift.dart';
import 'quran_books.dart';
import '../types/file_data.dart';

class QuranBookQitabs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleBn => text().nullable()();

  @JsonKey('image')
  TextColumn get imageData => text().map(const FileData()).nullable()();

  @JsonKey('document')
  TextColumn get documentData => text().map(const FileData()).nullable()();

  BoolColumn get published => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get quranBookId => text().references(QuranBooks, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
