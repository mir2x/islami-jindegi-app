import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';
import '../models/malfuzat_subcategory.dart';

class MalfuzatOfflineService {
  Future<Database> get _db => OfflineDatabaseHelper().database;

  // ───────────────────── Malfuzats ─────────────────────

  Future<List<MalfuzatItem>> queryMalfuzats({
    int page = 1,
    int perPage = 9,
    String? search,
    String? malfuzatAuthorId,
    String? malfuzatCategoryId,
    String? malfuzatSubcategoryId,
    bool? hasAudio,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (malfuzatAuthorId != null) {
      where.add('malfuzat_author_id = ?');
      args.add(malfuzatAuthorId);
    }
    if (malfuzatCategoryId != null) {
      where.add(
          'id IN (SELECT malfuzat_id FROM malfuzat_categorizations WHERE malfuzat_category_id = ?)');
      args.add(malfuzatCategoryId);
    }
    if (malfuzatSubcategoryId != null) {
      where.add(
          'id IN (SELECT malfuzat_id FROM malfuzat_subcategorizations WHERE malfuzat_subcategory_id = ?)');
      args.add(malfuzatSubcategoryId);
    }
    if (hasAudio == true) {
      where.add('has_audio = 1');
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    final rows = await db.query(
      'malfuzats',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position ASC',
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
    if (catRows.isEmpty) return [];

    final catIds = catRows.map((r) => r['id'].toString()).toList();
    final ph = List.filled(catIds.length, '?').join(',');
    final subRows = await db.query(
      'malfuzat_subcategories',
      where: 'malfuzat_category_id IN ($ph)',
      whereArgs: catIds,
      orderBy: 'position ASC',
    );

    final subsByCat = <String, List<MalfuzatSubcategory>>{};
    for (final r in subRows) {
      final catId = r['malfuzat_category_id'].toString();
      subsByCat
          .putIfAbsent(catId, () => [])
          .add(MalfuzatSubcategory.fromDb(r));
    }

    return catRows.map((row) {
      final id = row['id'].toString();
      return MalfuzatCategory.fromDb(row,
          subcategories: subsByCat[id] ?? []);
    }).toList();
  }

  Future<MalfuzatCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('malfuzat_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final subRows = await db.query('malfuzat_subcategories',
        where: 'malfuzat_category_id = ?',
        whereArgs: [id],
        orderBy: 'position ASC');
    final subs = subRows.map((r) => MalfuzatSubcategory.fromDb(r)).toList();
    return MalfuzatCategory.fromDb(rows.first, subcategories: subs);
  }

  Future<MalfuzatSubcategory?> findSubcategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('malfuzat_subcategories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MalfuzatSubcategory.fromDb(rows.first);
  }
}
