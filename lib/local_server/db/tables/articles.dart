import 'package:drift/drift.dart';
import 'article_authors.dart';

class Articles extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get body => text()();
  TextColumn get excerpt => text().nullable()();
  TextColumn get language => text()();
  TextColumn get documentData => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get publishedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get articleAuthorId => text().references(ArticleAuthors, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
