import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/page_content.dart';

class MasailOfflineService {
  // Bumped from 1 -> 2: pre-migration snapshots contain Ruby integer ids that
  // don't reconcile with the .NET API's Guid ids, so existing installs must
  // evict their cache and re-fetch once a Guid-based snapshot is published.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'masails', version: 2).database;
  Future<Database> get _miscDb =>
      OfflineDatabaseHelper(feature: 'misc', version: 1).database;

  // ───────────────────── Masails ─────────────────────

  Future<List<MasailItem>> queryMasails({
    int page = 1,
    int perPage = 9,
    String? search,
    String? authorId,
    String? categoryId,
    bool? hasAudio,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (authorId != null) {
      where.add('masail_author_id = ?');
      args.add(authorId);
    }
    if (categoryId != null) {
      where.add(
          'id IN (SELECT masail_id FROM masail_categorizations WHERE masail_category_id = ?)');
      args.add(categoryId);
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
  // Flat — no subcategory drill-down (matches the .NET category options
  // endpoint, which only returns top-level categories).

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

    return catRows.map((row) => MasailCategory.fromDb(row)).toList();
  }

  Future<MasailCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('masail_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MasailCategory.fromDb(rows.first);
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
