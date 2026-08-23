import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/bayan.dart';
import '../models/speaker.dart';
import '../models/bayan_category.dart';

class BayanOfflineService {
  // Bumped 1 -> 2 for Guid ids, then 2 -> 3 for the move from a prebuilt
  // downloaded file to an admin-curated, client-created-and-synced schema
  // (see OfflineDatabaseHelper / BayanSyncService) — existing installs must
  // rebuild their local schema and re-sync from the offline-sync endpoint.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'bayans', version: 3).database;

  Future<Database> get database => _db;

  // ───────────────────── Bayans ─────────────────────

  Future<List<Bayan>> queryBayans({
    int page = 1,
    int perPage = 9,
    String? search,
    String? speakerId,
    String? categoryId,
    String? dateFrom,
    String? dateTo,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (speakerId != null) {
      where.add('speaker_id = ?');
      args.add(speakerId);
    }
    if (categoryId != null) {
      where.add(
          'id IN (SELECT bayan_id FROM bayan_categorizations WHERE bayan_category_id = ?)');
      args.add(categoryId);
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    // `published_at` is stored as the API's ISO-8601 string. Comparing the day
    // prefix keeps the bounds inclusive whatever time component came with it.
    if (dateFrom != null && dateFrom.isNotEmpty) {
      where.add('substr(published_at, 1, 10) >= ?');
      args.add(dateFrom);
    }
    if (dateTo != null && dateTo.isNotEmpty) {
      where.add('substr(published_at, 1, 10) <= ?');
      args.add(dateTo);
    }

    final rows = await db.query(
      'bayans',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position DESC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );

    if (rows.isEmpty) return [];

    // Resolve speaker names
    final speakerIds = rows
        .map((r) => r['speaker_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    final speakerNames = <String, String>{};
    if (speakerIds.isNotEmpty) {
      final ph = List.filled(speakerIds.length, '?').join(',');
      final speakerRows = await db.rawQuery(
          'SELECT id, name FROM speakers WHERE id IN ($ph)', speakerIds);
      for (final r in speakerRows) {
        speakerNames[r['id'].toString()] = r['name'].toString();
      }
    }

    return rows.map((row) {
      final sid = row['speaker_id']?.toString();
      return Bayan.fromDb(row,
          speakerName: sid != null ? speakerNames[sid] : null);
    }).toList();
  }

  Future<Bayan?> findBayanById(String id) async {
    final db = await _db;
    final rows = await db.query(
      'bayans',
      where: 'id = ? AND published = 1',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;

    final row = rows.first;
    String? speakerName;
    final sid = row['speaker_id']?.toString();
    if (sid != null) {
      final sRows =
          await db.query('speakers', where: 'id = ?', whereArgs: [sid]);
      if (sRows.isNotEmpty) speakerName = sRows.first['name']?.toString();
    }
    return Bayan.fromDb(row, speakerName: speakerName);
  }

  // ───────────────────── Speakers ─────────────────────

  Future<List<Speaker>> querySpeakers({
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
      'speakers',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => Speaker.fromDb(r)).toList();
  }

  Future<Speaker?> findSpeakerById(String id) async {
    final db = await _db;
    final rows = await db.query('speakers', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Speaker.fromDb(rows.first);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<BayanCategory>> queryCategories({
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
      'bayan_categories',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => BayanCategory.fromDb(r)).toList();
  }

  Future<BayanCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows =
        await db.query('bayan_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return BayanCategory.fromDb(rows.first);
  }
}
