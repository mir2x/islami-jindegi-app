import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'tables/index.dart';

part 'local_database.g.dart';

@DriftDatabase(tables: [Books, Chapters, Subchapters, Masails])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase()
      : super(
          LazyDatabase(() async {
            // put the database file, called db.sqlite here, into the documents folder
            // for your app.
            final dbFolder = await getApplicationDocumentsDirectory();
            final file = File(p.join(dbFolder.path, 'init.sqlite3'));

            if (!await file.exists()) {
              // Extract the pre-populated database file from assets
              final blob = await rootBundle.load('assets/db/init.sqlite3');
              await file.writeAsBytes(
                blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
              );
            }

            return NativeDatabase(file);
          }),
        );

  // bump this number whenever a table definition has been added or changed.
  @override
  int get schemaVersion => 1;

  Future<List> query(String tableName, {params = const {}}) {
    switch (tableName) {
      case 'books':
        return queryBook(params);
      case 'chapters':
        return queryChapter(params);
      case 'masails':
        return queryMasail(params);
      default:
        return Future.value([]);
    }
  }

  Future? findById(String tableName, String id) {
    switch (tableName) {
      case 'books':
        return findBookById(id);
      case 'chapters':
        return findChapterById(id);
      case 'subchapters':
        return findSubchapterById(id);
      case 'masails':
        return findMasailById(id);
      default:
        return null;
    }
  }

  Future<List<Book>> queryBook(Map params) {
    return (select(books)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.position,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
  }

  Future<Book> findBookById(String id) {
    return (select(books)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Chapter>> queryChapter(Map params) {
    final query = select(chapters);
    query.where((t) => t.bookId.equals(params['bookId']));
    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<Chapter> findChapterById(String id) {
    return (select(chapters)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Subchapter> findSubchapterById(String id) {
    return (select(subchapters)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Masail>> queryMasail(Map params) {
    return select(masails).get();
  }

  Future<Masail> findMasailById(String id) {
    return (select(masails)..where((t) => t.id.equals(id))).getSingle();
  }
}
