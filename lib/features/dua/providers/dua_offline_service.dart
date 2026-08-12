import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

class DuaOfflineService {
  // Bumped 1 -> 2 for Guid ids, then 2 -> 3 for the move from a prebuilt
  // downloaded file to an admin-curated, client-created-and-synced schema
  // (see OfflineDatabaseHelper / DuaSyncService) — existing installs must
  // rebuild their local schema and re-sync from the offline-sync endpoint.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'duas', version: 3).database;

  // ───────────────────── Duas ─────────────────────

  Future<List<DuaItem>> queryDuas({
    int page = 1,
    int perPage = 20,
    String? search,
    String? categoryId,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (categoryId != null) {
      where.add(
          'id IN (SELECT dua_id FROM dua_categorizations WHERE dua_category_id = ?)');
      args.add(categoryId);
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    final rows = await db.query(
      'duas',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => DuaItem.fromDb(r)).toList();
  }

  Future<DuaItem?> findDuaById(String id) async {
    final db = await _db;
    final rows = await db.query('duas', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return DuaItem.fromDb(rows.first);
  }

  // ───────────────────── Categories ─────────────────────
  // Flat — no subcategory drill-down (matches the .NET category options
  // endpoint, which only returns top-level categories).

  Future<List<DuaCategory>> queryCategories({
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

    final rows = await db.query(
      'dua_categories',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => DuaCategory.fromDb(r)).toList();
  }

  Future<DuaCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows =
        await db.query('dua_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return DuaCategory.fromDb(rows.first);
  }
}
