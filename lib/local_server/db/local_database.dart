import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'tables/index.dart';

part 'local_database.g.dart';

@DriftDatabase(
  tables: [
    Surahs,
    Paras,
    Ayahs,
    Books,
    Chapters,
    Subchapters,
    Malfuzats,
    Masails,
    Duas,
    Articles,
    NamazTimes,
    Pages,
  ],
)
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
      case 'surahs':
        return querySurah(params);
      case 'paras':
        return queryPara(params);
      case 'ayahs':
        return queryAyah(params);
      case 'books':
        return queryBook(params);
      case 'chapters':
        return queryChapter(params);
      case 'malfuzats':
        return queryMalfuzat(params);
      case 'masails':
        return queryMasail(params);
      case 'duas':
        return queryDua(params);
      case 'articles':
        return queryArticle(params);
      case 'namazTimes':
        return queryNamazTime(params);
      case 'pages':
        return queryPage(params);
      default:
        return Future.value([]);
    }
  }

  Future? findById(String tableName, String id) {
    switch (tableName) {
      case 'surahs':
        return findSurahById(id);
      case 'paras':
        return findParaById(id);
      case 'ayahs':
        return findAyahById(id);
      case 'books':
        return findBookById(id);
      case 'chapters':
        return findChapterById(id);
      case 'subchapters':
        return findSubchapterById(id);
      case 'malfuzats':
        return findMalfuzatById(id);
      case 'masails':
        return findMasailById(id);
      case 'duas':
        return findDuaById(id);
      case 'articles':
        return findArticleById(id);
      case 'namazTimes':
        return findNamazTimeById(id);
      case 'pages':
        return findPageById(id);
      default:
        return null;
    }
  }

  Future<List<Surah>> querySurah(Map params) {
    var query = select(surahs);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<Surah> findSurahById(String id) {
    return (select(surahs)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Para>> queryPara(Map params) {
    var query = select(paras);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<Para> findParaById(String id) {
    return (select(paras)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Ayah>> queryAyah(Map params) {
    var query = select(ayahs);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    if (params.containsKey('surah_id')) {
      query.where((t) => t.surahId.equals(params['surah_id']));
    }

    if (params.containsKey('para_id')) {
      query.where((t) => t.paraId.equals(params['para_id']));
    }

    if (params.containsKey('sort') && params['sort'] == 'para-position') {
      query.orderBy([(t) => OrderingTerm(expression: t.paraPosition)]);
    } else {
      query.orderBy([(t) => OrderingTerm(expression: t.surahPosition)]);
    }

    return query.get();
  }

  Future<Ayah> findAyahById(String id) {
    return (select(ayahs)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Book>> queryBook(Map params) {
    var query = select(books);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.position, mode: OrderingMode.desc),
    ]);
    return query.get();
  }

  Future<Book> findBookById(String id) {
    return (select(books)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Chapter>> queryChapter(Map params) {
    var query = select(chapters);
    query.where((t) => t.bookId.equals(params['bookId']));

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<Chapter> findChapterById(String id) {
    return (select(chapters)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Subchapter> findSubchapterById(String id) {
    return (select(subchapters)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Malfuzat>> queryMalfuzat(Map params) {
    var query = select(malfuzats);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<Malfuzat> findMalfuzatById(String id) {
    return (select(malfuzats)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Masail>> queryMasail(Map params) {
    var query = select(masails);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    return query.get();
  }

  Future<Masail> findMasailById(String id) {
    return (select(masails)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Dua>> queryDua(Map params) {
    var query = select(duas);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<Dua> findDuaById(String id) {
    return (select(duas)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Article>> queryArticle(Map params) {
    var query = select(articles);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.position, mode: OrderingMode.desc),
    ]);
    return query.get();
  }

  Future<Article> findArticleById(String id) {
    return (select(articles)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Page>> queryPage(Map params) {
    var query = select(pages);

    if (params.containsKey('slug')) {
      query.where((t) => t.slug.equals(params['slug']));
    }

    query.limit(params['quantity'] ?? 20);

    return query.get();
  }

  Future<Page> findPageById(String id) {
    return (select(pages)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<NamazTime>> queryNamazTime(Map params) {
    var query = select(namazTimes);

    if (params.containsKey('slug')) {
      query.where((t) => t.slug.equals(params['slug']));
    }

    query.limit(params['quantity'] ?? 20);

    return query.get();
  }

  Future<NamazTime> findNamazTimeById(String id) {
    return (select(namazTimes)..where((t) => t.id.equals(id))).getSingle();
  }
}
