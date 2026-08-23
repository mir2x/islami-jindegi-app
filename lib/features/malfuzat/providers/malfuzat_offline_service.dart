import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';

class MalfuzatOfflineService {
  // Bumped 1 -> 2 for Guid ids, then 2 -> 3 for the move from a prebuilt
  // downloaded file to an admin-curated, client-created-and-synced schema
  // (see OfflineDatabaseHelper / MalfuzatSyncService) — existing installs
  // must rebuild their local schema and re-sync from the offline-sync
  // endpoint.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'malfuzats', version: 3).database;

  // ───────────────────── Malfuzats ─────────────────────

  Future<List<MalfuzatItem>> queryMalfuzats({
    int page = 1,
    int perPage = 9,
    String? search,
    String? authorId,
    String? categoryId,
    bool? hasAudio,
    String? dateFrom,
    String? dateTo,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (authorId != null) {
      where.add('malfuzat_author_id = ?');
      args.add(authorId);
    }
    if (categoryId != null) {
      where.add(
          'id IN (SELECT malfuzat_id FROM malfuzat_categorizations WHERE malfuzat_category_id = ?)');
      args.add(categoryId);
    }
    if (hasAudio == true) {
      where.add('has_audio = 1');
    } else if (hasAudio == false) {
      where.add('has_audio = 0');
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    // Dates are stored as the API's ISO-8601 strings, so comparing the day
    // prefix keeps the bounds inclusive whatever time component came with them.
    // `published_at` is null for most content carried over from the legacy
    // backend, which kept only a creation date — the same fallback the API
    // applies, so online and offline results match.
    if (dateFrom != null && dateFrom.isNotEmpty) {
      where.add('substr(COALESCE(published_at, created_at), 1, 10) >= ?');
      args.add(dateFrom);
    }
    if (dateTo != null && dateTo.isNotEmpty) {
      where.add('substr(COALESCE(published_at, created_at), 1, 10) <= ?');
      args.add(dateTo);
    }

    final rows = await db.query(
      'malfuzats',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position DESC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );

    if (rows.isEmpty) return [];

    // Resolve author names
    final authorIds = rows
        .map((r) => r['malfuzat_author_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    final authorNames = <String, String>{};
    if (authorIds.isNotEmpty) {
      final ph = List.filled(authorIds.length, '?').join(',');
      final authorRows = await db.rawQuery(
          'SELECT id, name FROM malfuzat_authors WHERE id IN ($ph)', authorIds);
      for (final r in authorRows) {
        authorNames[r['id'].toString()] = r['name'].toString();
      }
    }

    return rows.map((row) {
      final aid = row['malfuzat_author_id']?.toString();
      return MalfuzatItem.fromDb(row,
          authorName: aid != null ? authorNames[aid] : null);
    }).toList();
  }

  Future<MalfuzatItem?> findMalfuzatById(String id) async {
    final db = await _db;
    final rows =
        await db.query('malfuzats', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final row = rows.first;
    String? authorName;
    final aid = row['malfuzat_author_id']?.toString();
    if (aid != null) {
      final aRows = await db
          .query('malfuzat_authors', where: 'id = ?', whereArgs: [aid]);
      if (aRows.isNotEmpty) authorName = aRows.first['name']?.toString();
    }
    return MalfuzatItem.fromDb(row, authorName: authorName);
  }

  Future<MalfuzatItem?> findPreviousMalfuzatByPosition(int position) async {
    final db = await _db;
    final rows = await db.query(
      'malfuzats',
      where: 'position < ?',
      whereArgs: [position],
      orderBy: 'position DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return findMalfuzatById(rows.first['id'].toString());
  }

  Future<MalfuzatItem?> findNextMalfuzatByPosition(int position) async {
    final db = await _db;
    final rows = await db.query(
      'malfuzats',
      where: 'position > ?',
      whereArgs: [position],
      orderBy: 'position ASC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return findMalfuzatById(rows.first['id'].toString());
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<MalfuzatAuthor>> queryAuthors({
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
      'malfuzat_authors',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => MalfuzatAuthor.fromDb(r)).toList();
  }

  Future<MalfuzatAuthor?> findAuthorById(String id) async {
    final db = await _db;
    final rows =
        await db.query('malfuzat_authors', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MalfuzatAuthor.fromDb(rows.first);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<MalfuzatCategory>> queryCategories({
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
      'malfuzat_categories',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return catRows.map((row) => MalfuzatCategory.fromDb(row)).toList();
  }

  Future<MalfuzatCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('malfuzat_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MalfuzatCategory.fromDb(rows.first);
  }
}
