import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:collection/collection.dart';
import 'tables/index.dart';
import 'types/file_data.dart';

part 'local_database.g.dart';

@DriftDatabase(
  tables: [
    Surahs,
    Paras,
    Ayahs,
    AyahTranslations,
    Books,
    Chapters,
    Subchapters,
    Authors,
    BooksAuthors,
    Speakers,
    Bayans,
    MalfuzatAuthors,
    Malfuzats,
    MasailAuthors,
    Masails,
    Duas,
    ArticleAuthors,
    Articles,
    Madrasahs,
    MadrasahInfos,
    NamazTimes,
    News,
    Pages,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase()
      : super(
          LazyDatabase(() async {
            int dataVersion = 1;

            final dbFolder = await getApplicationDocumentsDirectory();
            final file = File(
              p.join(dbFolder.path, 'offline_data_$dataVersion.sqlite3'),
            );

            if (!await file.exists()) {
              // delete previous file
              final previousFiles = Glob(
                p.join(dbFolder.path, 'offline_data_*.sqlite3'),
              );
              for (var previousFile in previousFiles.listSync()) {
                await previousFile.delete();
              }

              // load current file
              final blob = await rootBundle
                  .load('assets/db/offline_data_$dataVersion.sqlite3');
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

  Future<List> query(String tableName, {params = const {}}) async {
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
      case 'subchapters':
        return querySubchapter(params);
      case 'bayans':
        return queryBayan(params);
      case 'malfuzats':
        return queryMalfuzat(params);
      case 'masails':
        return queryMasail(params);
      case 'duas':
        return queryDua(params);
      case 'articles':
        return queryArticle(params);
      case 'madrasahs':
        return queryMadrasah(params);
      case 'madrasahInfos':
        return queryMadrasahInfo(params);
      case 'namazTimes':
        return queryNamazTime(params);
      case 'news':
        return queryNews(params);
      case 'pages':
        return queryPage(params);
      default:
        return [];
    }
  }

  Future? findById(String tableName, String id, {params = const {}}) async {
    switch (tableName) {
      case 'surahs':
        return findSurahById(id);
      case 'paras':
        return findParaById(id);
      case 'ayahs':
        return findAyahById(id, params);
      case 'ayahTranslations':
        return findAyahTranslationById(id);
      case 'books':
        return findBookById(id);
      case 'chapters':
        return findChapterById(id);
      case 'subchapters':
        return findSubchapterById(id);
      case 'authors':
        return findAuthorById(id);
      case 'speakers':
        return findSpeakerById(id);
      case 'bayans':
        return findBayanById(id, params);
      case 'malfuzatAuthors':
        return findMalfuzatAuthorById(id);
      case 'malfuzats':
        return findMalfuzatById(id, params);
      case 'masails':
        return findMasailById(id);
      case 'duas':
        return findDuaById(id);
      case 'articleAuthors':
        return findArticleAuthorById(id);
      case 'articles':
        return findArticleById(id, params);
      case 'madrasahs':
        return findMadrasahById(id, params);
      case 'madrasahInfos':
        return findMadrasahInfoById(id, params);
      case 'namazTimes':
        return findNamazTimeById(id);
      case 'news':
        return findNewsById(id);
      case 'pages':
        return findPageById(id);
      default:
        return null;
    }
  }

  Future<List<Surah>> querySurah(Map params) {
    var query = select(surahs);

    if (params.containsKey('slug')) {
      query.where((t) => t.slug.equals(params['slug'].toString()));
    }

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

  Future<Surah?> findSurahById(String id) {
    return (select(surahs)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Para>> queryPara(Map params) {
    var query = select(paras);

    if (params.containsKey('slug')) {
      query.where((t) => t.slug.equals(params['slug'].toString()));
    }

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

  Future<Para?> findParaById(String id) {
    return (select(paras)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List> queryAyah(Map params) async {
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
      query.where((t) => t.surahId.equals(params['surah_id'].toString()));
    }

    if (params.containsKey('para_id')) {
      query.where((t) => t.paraId.equals(params['para_id'].toString()));
    }

    if (params.containsKey('sort') && params['sort'] == 'para-position') {
      query.orderBy([(t) => OrderingTerm(expression: t.paraPosition)]);
    } else {
      query.orderBy([(t) => OrderingTerm(expression: t.surahPosition)]);
    }

    var ayahItems = await query.get();

    if (params.containsKey('include') &&
        params['include'] == 'ayah-translations') {
      Map<String, Ayah> idToAyahs = <String, Ayah>{
        for (var v in ayahItems) v.id: v
      };
      var ids = idToAyahs.keys;

      var translationItems = await (select(ayahTranslations)
            ..where((s) => s.ayahId.isIn(ids)))
          .get();

      var idToTranslations =
          groupBy(translationItems, (AyahTranslation obj) => obj.ayahId);

      var ayahsWithTranslations = ids.map((id) {
        return {
          'ayahs': idToAyahs[id],
          'relationships': {
            'ayah-translations': idToTranslations[id] ?? [],
          }
        };
      }).toList();

      return ayahsWithTranslations;
    } else {
      return ayahItems;
    }
  }

  Future<dynamic> findAyahById(String id, Map params) async {
    var ayah =
        await (select(ayahs)..where((t) => t.id.equals(id))).getSingleOrNull();

    if (ayah != null &&
        params.containsKey('include') &&
        params['include'] == 'surah,ayah-translations') {
      var surah = await (select(surahs)
            ..where((s) => s.id.equals(ayah.surahId)))
          .getSingle();

      var translations = await (select(ayahTranslations)
            ..where((s) => s.ayahId.equals(ayah.id)))
          .get();

      var ayahWithRelations = {
        'ayahs': ayah,
        'relationships': {
          'surah': surah,
          'ayah-translations': translations,
        }
      };

      return ayahWithRelations;
    } else {
      return ayah;
    }
  }

  Future<AyahTranslation?> findAyahTranslationById(String id) {
    return (select(ayahTranslations)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List> queryBook(Map params) async {
    var query = select(books);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);

    var bookItems = await query.get();

    if (params.containsKey('include') && params['include'] == 'authors') {
      Map<String, Book> idToBooks = <String, Book>{
        for (var v in bookItems) v.id: v
      };
      var ids = idToBooks.keys;

      var authorItems = await (select(authors).join([
        innerJoin(booksAuthors, booksAuthors.authorId.equalsExp(authors.id)),
      ])
            ..where(booksAuthors.bookId.isIn(ids)))
          .map((row) {
        return {
          'bookId': row.readTable(booksAuthors).bookId,
          'author': row.readTable(authors)
        };
      }).get();

      var idToAuthors = <String, List>{};
      for (Map element in authorItems) {
        (idToAuthors[element['bookId']] ??= []).add(element['author']);
      }

      var booksWithAuthors = ids.map((id) {
        return {
          'books': idToBooks[id],
          'relationships': {
            'authors': idToAuthors[id] ?? [],
          }
        };
      }).toList();

      return booksWithAuthors;
    } else {
      return bookItems;
    }
  }

  Future<Book?> findBookById(String id) {
    return (select(books)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List> queryChapter(Map params) async {
    var query = select(chapters);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    if (params.containsKey('bookId')) {
      query.where((r) => r.bookId.equals(params['bookId'].toString()));
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);

    var chapterItems = await query.get();

    if (params.containsKey('include') && params['include'] == 'subchapters') {
      Map<String, Chapter> idToChapters = <String, Chapter>{
        for (var v in chapterItems) v.id: v
      };
      var ids = idToChapters.keys;

      var subchapterItems = await (select(subchapters)
            ..where((s) => s.chapterId.isIn(ids)))
          .get();

      var idToSubchapters =
          groupBy(subchapterItems, (Subchapter obj) => obj.chapterId);

      var chaptersWithSubchapters = ids.map((id) {
        return {
          'chapters': idToChapters[id],
          'relationships': {
            'subchapters': idToSubchapters[id] ?? [],
          }
        };
      }).toList();

      return chaptersWithSubchapters;
    } else {
      return chapterItems;
    }
  }

  Future<Chapter?> findChapterById(String id) {
    return (select(chapters)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Subchapter>> querySubchapter(Map params) {
    var query = select(subchapters);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    if (params.containsKey('chapterId')) {
      query.where((r) => r.chapterId.equals(params['chapterId'].toString()));
    }

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

  Future<Subchapter?> findSubchapterById(String id) {
    return (select(subchapters)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Author?> findAuthorById(String id) {
    return (select(authors)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<Speaker?> findSpeakerById(String id) {
    return (select(speakers)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List> queryBayan(Map params) async {
    var query = select(bayans);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([
      (t) => OrderingTerm(
            expression: t.position,
            mode: OrderingMode.desc,
          )
    ]);

    var bayanItems = await query.get();

    if (params.containsKey('include') && params['include'] == 'speaker') {
      var speakerIds =
          bayanItems.map((item) => item.speakerId).toSet().toList();

      var speakerItems =
          await (select(speakers)..where((s) => s.id.isIn(speakerIds))).get();

      Map<String, Speaker> idToSpeakers = <String, Speaker>{
        for (var v in speakerItems) v.id: v
      };

      var bayansWithSpeaker = bayanItems.map((item) {
        return {
          'bayans': item,
          'relationships': {
            'speaker': idToSpeakers[item.speakerId],
          }
        };
      }).toList();

      return bayansWithSpeaker;
    } else {
      return bayanItems;
    }
  }

  Future<dynamic> findBayanById(String id, Map params) async {
    var bayan =
        await (select(bayans)..where((t) => t.id.equals(id))).getSingleOrNull();

    if (bayan != null &&
        params.containsKey('include') &&
        params['include'] == 'speaker') {
      var speaker = await (select(speakers)
            ..where((s) => s.id.equals(bayan.speakerId)))
          .getSingle();

      var bayanWithSpeaker = {
        'bayans': bayan,
        'relationships': {
          'speaker': speaker,
        }
      };

      return bayanWithSpeaker;
    } else {
      return bayan;
    }
  }

  Future<MalfuzatAuthor?> findMalfuzatAuthorById(String id) {
    return (select(malfuzatAuthors)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List> queryMalfuzat(Map params) async {
    var query = select(malfuzats);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);

    var malfuzatItems = await query.get();

    if (params.containsKey('include') &&
        params['include'] == 'malfuzat-author') {
      var authorIds =
          malfuzatItems.map((item) => item.malfuzatAuthorId).toSet().toList();

      var authorItems = await (select(malfuzatAuthors)
            ..where((s) => s.id.isIn(authorIds)))
          .get();

      Map<String, MalfuzatAuthor> idToAuthors = <String, MalfuzatAuthor>{
        for (var v in authorItems) v.id: v
      };

      var malfuzatsWithAuthor = malfuzatItems.map((item) {
        return {
          'malfuzats': item,
          'relationships': {
            'malfuzat-author': idToAuthors[item.malfuzatAuthorId],
          }
        };
      }).toList();

      return malfuzatsWithAuthor;
    } else {
      return malfuzatItems;
    }
  }

  Future<dynamic> findMalfuzatById(String id, Map params) async {
    var malfuzat = await (select(malfuzats)..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (malfuzat != null &&
        params.containsKey('include') &&
        params['include'] == 'malfuzat-author') {
      var author = await (select(malfuzatAuthors)
            ..where((s) => s.id.equals(malfuzat.malfuzatAuthorId)))
          .getSingle();

      var malfuzatWithAuthor = {
        'malfuzats': malfuzat,
        'relationships': {
          'malfuzat-author': author,
        }
      };

      return malfuzatWithAuthor;
    } else {
      return malfuzat;
    }
  }

  Future<List<Masail>> queryMasail(Map params) {
    var query = select(masails);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

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

  Future<Masail?> findMasailById(String id) {
    return (select(masails)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Dua>> queryDua(Map params) {
    var query = select(duas);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

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

  Future<Dua?> findDuaById(String id) {
    return (select(duas)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<ArticleAuthor?> findArticleAuthorById(String id) {
    return (select(articleAuthors)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List> queryArticle(Map params) async {
    var query = select(articles);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);

    var articleItems = await query.get();

    if (params.containsKey('include') &&
        params['include'] == 'article-author') {
      var authorIds =
          articleItems.map((item) => item.articleAuthorId).toSet().toList();

      var authorItems = await (select(articleAuthors)
            ..where((s) => s.id.isIn(authorIds)))
          .get();

      Map<String, ArticleAuthor> idToAuthors = <String, ArticleAuthor>{
        for (var v in authorItems) v.id: v
      };

      var articlesWithAuthor = articleItems.map((item) {
        return {
          'articles': item,
          'relationships': {
            'article-author': idToAuthors[item.articleAuthorId],
          }
        };
      }).toList();

      return articlesWithAuthor;
    } else {
      return articleItems;
    }
  }

  Future<dynamic> findArticleById(String id, Map params) async {
    var article = await (select(articles)..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (article != null &&
        params.containsKey('include') &&
        params['include'] == 'article-author') {
      var author = await (select(articleAuthors)
            ..where((s) => s.id.equals(article.articleAuthorId)))
          .getSingle();

      var articleWithAuthor = {
        'articles': article,
        'relationships': {
          'article-author': author,
        }
      };

      return articleWithAuthor;
    } else {
      return article;
    }
  }

  Future<List<Madrasah>> queryMadrasah(Map params) {
    var query = select(madrasahs);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

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

  Future<dynamic> findMadrasahById(String id, Map params) async {
    var madrasah = await (select(madrasahs)..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (madrasah != null &&
        params.containsKey('include') &&
        params['include'] == 'madrasah-infos') {
      var infos = await (select(madrasahInfos)
            ..where((s) => s.madrasahId.equals(madrasah.id)))
          .get();

      var madrasahWithInfos = {
        'madrasahs': madrasah,
        'relationships': {
          'madrasah-infos': infos,
        }
      };

      return madrasahWithInfos;
    } else {
      return madrasah;
    }
  }

  Future<List<MadrasahInfo>> queryMadrasahInfo(Map params) {
    var query = select(madrasahInfos);

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    if (params.containsKey('madrasahId')) {
      query.where((r) => r.madrasahId.equals(params['madrasahId']));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.get();
  }

  Future<dynamic> findMadrasahInfoById(String id, Map params) async {
    var info = await (select(madrasahInfos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (info != null &&
        params.containsKey('include') &&
        params['include'] == 'madrasah') {
      var madrasah = await (select(madrasahs)
            ..where((s) => s.id.equals(info.madrasahId)))
          .getSingle();

      var infoWithMadrasah = {
        'madrasahInfo': info,
        'relationships': {
          'madrasah': madrasah,
        }
      };

      return infoWithMadrasah;
    } else {
      return info;
    }
  }

  Future<List<New>> queryNews(Map params) {
    var query = select(news);

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.publishedAt, mode: OrderingMode.desc),
    ]);

    if (params.containsKey('gtPublishedAt')) {
      query.where(
        (r) => r.publishedAt.isBiggerThanValue(params['gtPublishedAt']),
      );
      query.orderBy([
        (t) => OrderingTerm(expression: t.publishedAt, mode: OrderingMode.asc),
      ]);
    }

    if (params.containsKey('ltPublishedAt')) {
      query.where(
        (r) => r.publishedAt.isSmallerThanValue(params['ltPublishedAt']),
      );
    }

    return query.get();
  }

  Future<New?> findNewsById(String id) {
    return (select(news)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Page>> queryPage(Map params) {
    var query = select(pages);

    if (params.containsKey('slug')) {
      query.where((t) => t.slug.equals(params['slug'].toString()));
    }

    query.limit(params['quantity'] ?? 20);

    return query.get();
  }

  Future<Page?> findPageById(String id) {
    return (select(pages)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<NamazTime>> queryNamazTime(Map params) {
    var query = select(namazTimes);

    if (params.containsKey('slug')) {
      query.where((t) => t.slug.equals(params['slug'].toString()));
    }

    if (params.containsKey('position')) {
      query.where((r) => r.position.equals(params['position']));
    }

    query.limit(params['quantity'] ?? 20);

    return query.get();
  }

  Future<NamazTime?> findNamazTimeById(String id) {
    return (select(namazTimes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }
}
