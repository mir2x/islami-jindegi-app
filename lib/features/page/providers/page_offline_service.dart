import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/page_item.dart';

/// Reads the admin-curated offline copy of static content pages (donation,
/// important matters, contact, about, …) out of the shared `misc` database.
///
/// The rows are written by `MasailSyncService._syncPages()`, which pulls
/// `/pages/offline-sync` on every sync cycle — Pages ride along under the
/// `masails` feature key rather than having their own entry in
/// `offlineDbFeatures`. Only pages flagged `IsOfflineAvailable` in the admin
/// panel are in that feed, so an unflagged slug legitimately has no local row.
class PageOfflineService {
  // Version must match the one `MasailSyncService` opens `misc` with —
  // sqflite treats a mismatch as a migration, not a second connection.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'misc', version: 2).database;

  Future<PageItem?> findBySlug(String slug) async {
    final db = await _db;
    final rows =
        await db.query('pages', where: 'slug = ?', whereArgs: [slug], limit: 1);
    if (rows.isEmpty) return null;
    return PageItem.fromDb(rows.first);
  }
}
