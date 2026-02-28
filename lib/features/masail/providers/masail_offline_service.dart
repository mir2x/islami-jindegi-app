import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/masail_subcategory.dart';
import '../models/page_content.dart';

class MasailOfflineService {
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'masails', version: 1).database;
  Future<Database> get _miscDb =>
      OfflineDatabaseHelper(feature: 'misc', version: 1).database;

  // ───────────────────── Masails ─────────────────────

  Future<List<MasailItem>> queryMasails({
    int page = 1,
    int perPage = 9,
    String? search,
    String? masailAuthorId,
    String? masailCategoryId,
    String? masailSubcategoryId,
    bool? hasAudio,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (masailAuthorId != null) {
      where.add('masail_author_id = ?');
      args.add(masailAuthorId);
    }
    if (masailCategoryId != null) {
      where.add(
          'id IN (SELECT masail_id FROM masail_categorizations WHERE masail_category_id = ?)');
      args.add(masailCategoryId);
    }
    if (masailSubcategoryId != null) {
      where.add(
          'id IN (SELECT masail_id FROM masail_subcategorizations WHERE masail_subcategory_id = ?)');
      args.add(masailSubcategoryId);
    }
    if (hasAudio == true) {
      where.add('has_audio = 1');
    } else if (hasAudio == false) {
      where.add('has_audio = 0');
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR question LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    final rows = await db.query(
      'masails',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );

    if (rows.isEmpty) return [];

    // Resolve author names
    final authorIds = rows
        .map((r) => r['masail_author_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    final authorNames = <String, String>{};
    if (authorIds.isNotEmpty) {
      final ph = List.filled(authorIds.length, '?').join(',');
      final authorRows = await db.rawQuery(
          'SELECT id, name FROM masail_authors WHERE id IN ($ph)', authorIds);
      for (final r in authorRows) {
        authorNames[r['id'].toString()] = r['name'].toString();
      }
    }

    return rows.map((row) {
      final aid = row['masail_author_id']?.toString();
      return MasailItem.fromDb(row,
          authorName: aid != null ? authorNames[aid] : null);
    }).toList();
  }

  Future<MasailItem?> findMasailById(String id) async {
    final db = await _db;
    final rows =
        await db.query('masails', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final row = rows.first;
    String? authorName;
    final aid = row['masail_author_id']?.toString();
    if (aid != null) {
      final aRows =
          await db.query('masail_authors', where: 'id = ?', whereArgs: [aid]);
      if (aRows.isNotEmpty) authorName = aRows.first['name']?.toString();
    }
    return MasailItem.fromDb(row, authorName: authorName);
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<MasailAuthor>> queryAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      where.add('name LIKE ?');
      args.add('%$search%');
    }

    final rows = await db.query(
      'masail_authors',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => MasailAuthor.fromDb(r)).toList();
  }

  Future<MasailAuthor?> findAuthorById(String id) async {
    final db = await _db;
    final rows =
        await db.query('masail_authors', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MasailAuthor.fromDb(rows.first);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<MasailCategory>> queryCategories({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      where.add('title LIKE ?');
      args.add('%$search%');
    }

    final catRows = await db.query(
      'masail_categories',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    if (catRows.isEmpty) return [];

    final catIds = catRows.map((r) => r['id'].toString()).toList();
    final ph = List.filled(catIds.length, '?').join(',');
    final subRows = await db.query(
      'masail_subcategories',
      where: 'masail_category_id IN ($ph)',
      whereArgs: catIds,
      orderBy: 'position ASC',
    );

    final subsByCat = <String, List<MasailSubcategory>>{};
    for (final r in subRows) {
      final catId = r['masail_category_id'].toString();
      subsByCat.putIfAbsent(catId, () => []).add(MasailSubcategory.fromDb(r));
    }

    return catRows.map((row) {
      final id = row['id'].toString();
      return MasailCategory.fromDb(row, subcategories: subsByCat[id] ?? []);
    }).toList();
  }

  Future<MasailCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('masail_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final subRows = await db.query('masail_subcategories',
        where: 'masail_category_id = ?',
        whereArgs: [id],
        orderBy: 'position ASC');
    final subs = subRows.map((r) => MasailSubcategory.fromDb(r)).toList();
    return MasailCategory.fromDb(rows.first, subcategories: subs);
  }

  Future<MasailSubcategory?> findSubcategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('masail_subcategories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MasailSubcategory.fromDb(rows.first);
  }

  // ───────────────────── Pages ─────────────────────

  Future<PageContent?> findPageBySlug(String slug) async {
    final db = await _miscDb;
    final rows =
        await db.query('pages', where: 'slug = ?', whereArgs: [slug], limit: 1);
    if (rows.isEmpty) return null;
    return PageContent.fromDb(rows.first);
  }
}
