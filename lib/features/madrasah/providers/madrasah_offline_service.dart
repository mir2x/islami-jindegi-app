import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/madrasah.dart';
import '../models/madrasah_info.dart';
import '../models/madrasah_photo.dart';

class MadrasahOfflineService {
  // Bumped 1 -> 2 for Guid ids, then 2 -> 3 for the move from a prebuilt
  // downloaded file to an admin-curated, client-created-and-synced schema
  // (see OfflineDatabaseHelper / MadrasahSyncService) — existing installs
  // must rebuild their local schema and re-sync from the offline-sync
  // endpoint.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'madrasahs', version: 3).database;

  // ───────────────────── Madrasahs ─────────────────────

  Future<List<MadrasahItem>> queryMadrasahs({
    int page = 1,
    int perPage = 9,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    final rows = await db.query(
      'madrasahs',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => MadrasahItem.fromDb(r)).toList();
  }

  /// Loads a madrasah with its infos and photos always joined in — the .NET
  /// API's detail response always nests both, so there's no equivalent of
  /// the old `includeInfos`/`includePhotos` flags to thread through here.
  Future<MadrasahItem?> findMadrasahById(String id) async {
    final db = await _db;
    final rows =
        await db.query('madrasahs', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final infoRows = await db.query('madrasah_infos',
        where: 'madrasah_id = ?', whereArgs: [id], orderBy: 'position ASC');
    final infos = infoRows.map((r) => MadrasahInfoItem.fromDb(r)).toList();

    final photoRows = await db.query('madrasah_photos',
        where: 'madrasah_id = ?', whereArgs: [id], orderBy: 'position ASC');
    final photos = photoRows.map((r) => MadrasahPhotoItem.fromDb(r)).toList();

    return MadrasahItem.fromDb(rows.first, infos: infos, photos: photos);
  }
}
