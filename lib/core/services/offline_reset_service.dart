import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../utils/offline_database_helper.dart';
import '../utils/offline_storage.dart';

/// Bump this **only** when a release must discard every device's existing
/// offline store and re-sync from scratch.
///
/// Version 1 is the .NET backend cut-over: ids, shapes and media URLs all
/// changed, so anything synced from the old API is unusable. Ordinary
/// releases — including ones that bump a schema version in
/// `OfflineDatabaseHelper` — must leave this alone; that path already
/// rebuilds the affected tables and clears their watermarks on its own.
const int currentOfflineResetVersion = 1;

const _markerKey = 'offline_store_reset_version';
const _legacyPollThrottleKey = 'last_offline_sync_at';

/// One-time wipe of the local offline store: SQLite databases, cached media
/// and every sync watermark.
///
/// Idempotent and cheap once applied — a single preference read — so it's
/// safe to call from every entry point that might start a sync, including
/// the background push isolate.
class OfflineResetService {
  static Future<void> ensureApplied() async {
    final prefs = await SharedPreferences.getInstance();
    if ((prefs.getInt(_markerKey) ?? 0) >= currentOfflineResetVersion) return;

    try {
      await _wipe(prefs);
    } catch (error, stackTrace) {
      // A partial wipe is survivable — the marker stays unset so the next
      // launch tries again — but never let it block app start.
      debugPrint('Offline store reset failed: $error\n$stackTrace');
      return;
    }

    await prefs.setInt(_markerKey, currentOfflineResetVersion);
  }

  static Future<void> _wipe(SharedPreferences prefs) async {
    final dbRoot = await getDatabasesPath();

    for (final feature in registeredOfflineFeatures) {
      // Close first: deleting the file under an open handle leaves the cached
      // connection pointing at a database that no longer exists.
      await OfflineDatabaseHelper.evict(feature);
      await deleteDatabase(p.join(dbRoot, '$feature.sqlite3'));
      await clearOfflineWatermarks(feature);
    }

    final images = await OfflineStorage.imagesRoot();
    if (await images.exists()) await images.delete(recursive: true);

    // Force the next launch to sync immediately rather than waiting out the
    // poll throttle left over from the previous build.
    await prefs.remove(_legacyPollThrottleKey);
  }
}
