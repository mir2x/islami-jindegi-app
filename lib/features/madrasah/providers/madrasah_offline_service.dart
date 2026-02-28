import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/madrasah.dart';
import '../models/madrasah_info.dart';
import '../models/madrasah_photo.dart';

class MadrasahOfflineService {
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'madrasahs', version: 1).database;

  // ───────────────────── Madrasahs ─────────────────────

  Future<List<MadrasahItem>> queryMadrasahs({
    int page = 1,
    int perPage = 9,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    final rows = await db.query(
      'madrasahs',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => MadrasahItem.fromDb(r)).toList();
  }

  Future<MadrasahItem?> findMadrasahById(String id,
      {bool includeInfos = false, bool includePhotos = false}) async {
    final db = await _db;
    final rows =
        await db.query('madrasahs', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    List<MadrasahInfoItem> infos = [];
    if (includeInfos) {
      final infoRows = await db.query('madrasah_infos',
          where: 'madrasah_id = ?', whereArgs: [id], orderBy: 'position ASC');
      infos = infoRows.map((r) => MadrasahInfoItem.fromDb(r)).toList();
    }

    List<MadrasahPhotoItem> photos = [];
    if (includePhotos) {
      final photoRows = await db.query('madrasah_photos',
          where: 'madrasah_id = ?', whereArgs: [id], orderBy: 'position ASC');
      photos = photoRows.map((r) => MadrasahPhotoItem.fromDb(r)).toList();
    }

    return MadrasahItem.fromDb(rows.first, infos: infos, photos: photos);
  }

  // ───────────────────── Infos ─────────────────────

  Future<MadrasahInfoItem?> findInfoById(String id,
      {bool includeMadrasah = false}) async {
    final db = await _db;
    final rows =
        await db.query('madrasah_infos', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    String? madrasahTitle;
    if (includeMadrasah) {
      final mid = rows.first['madrasah_id']?.toString();
      if (mid != null) {
        final mRows =
            await db.query('madrasahs', where: 'id = ?', whereArgs: [mid]);
        if (mRows.isNotEmpty) madrasahTitle = mRows.first['title']?.toString();
      }
    }
    return MadrasahInfoItem.fromDb(rows.first, madrasahTitle: madrasahTitle);
  }
}
