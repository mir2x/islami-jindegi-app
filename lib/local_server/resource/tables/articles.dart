import 'package:drift/drift.dart';
import 'article_authors.dart';
import '../types/file_data.dart';

class Articles extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();

  @JsonKey('document')
  TextColumn get documentData => text().map(const FileData()).nullable()();

  IntColumn get position => integer()();
  TextColumn get publishedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get articleAuthorId => text().references(ArticleAuthors, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
