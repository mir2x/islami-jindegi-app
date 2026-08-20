import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/offline_database_helper.dart';

/// Shared HTTP + transaction plumbing for the per-feature `X_sync_service.dart`
/// files. Each sync service fetches only what changed since its last sync
/// from `/{domain}/offline-sync?since=`, and separately diffs
/// `/{domain}/offline-ids` against what's stored locally to find items that
/// fell out of the admin-curated offline set — then applies both to local
/// SQLite via [runSync], upserting changed rows and deleting removed ones
/// without touching anything unaffected by this pass.
class OfflineSyncEngine {
  OfflineSyncEngine()
      : _dio = Dio(
          BaseOptions(
            baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
            // A sync pass with no timeout can stall indefinitely on a network
            // that connects but never delivers, which is exactly when the
            // offline copies matter most. `receiveTimeout` is Dio's
            // between-chunks budget, not a whole-response one, so a generous
            // value stays safe for the larger domain feeds.
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

  final Dio _dio;

  String _sinceKey(String feature) => 'offline_sync_since_$feature';

  /// Items changed since [feature]'s last successful sync, plus the server's
  /// clock time for this request (from the `X-Sync-Server-Time` response
  /// header). Persist that via [commitSince] once the batch is applied, so a
  /// zero-change sync still advances the watermark instead of re-requesting
  /// the same range forever.
  Future<(List<dynamic> items, String? serverTime)> fetchChangedSet(
    String endpointPath,
    String feature,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final since = prefs.getString(_sinceKey(feature));

    final response = await _dio.get(
      endpointPath,
      queryParameters: since == null ? null : {'since': since},
    );
    final items = (response.data as List?) ?? [];
    final serverTime = response.headers.value('x-sync-server-time');
    return (items, serverTime);
  }

  /// The full set of currently offline-available ids from [idsPath] (e.g.
  /// `/books/offline-ids`) — the API has no delete/tombstone feed, so this is
  /// how the client detects items that were un-flagged or deleted.
  Future<Set<String>> fetchOfflineIds(String idsPath) async {
    final response = await _dio.get(idsPath);
    final ids = (response.data as List?) ?? [];
    return ids.map((id) => id.toString()).toSet();
  }

  Future<void> commitSince(String feature, String? serverTime) async {
    if (serverTime == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sinceKey(feature), serverTime);
  }

  Future<Response<dynamic>> downloadFile(String url, String savePath) {
    return _dio.download(url, savePath);
  }

  /// Opens [feature]'s local database and runs [apply] inside one
  /// transaction.
  Future<void> runSync({
    required String feature,
    required int version,
    required Future<void> Function(Transaction txn) apply,
  }) async {
    final db = await OfflineDatabaseHelper(feature: feature, version: version)
        .database;
    await db.transaction(apply);
  }

  /// Upserts [rows] into [table] by primary key (or unique constraint, for
  /// join tables). Used for both top-level content rows and shared lookup
  /// rows (authors/categories/speakers) — lookup rows are additive-only here
  /// and never deleted incrementally, since a stale unused row costs nothing
  /// and they're rarely removed.
  Future<void> upsertRows(
    Transaction txn,
    String table,
    List<Map<String, dynamic>> rows,
  ) async {
    for (final row in rows) {
      await txn.insert(table, row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// Deletes rows from [table] whose `id` is in [ids] — for removing
  /// top-level rows that fell out of the offline-curated set.
  Future<void> deleteByIds(
      Transaction txn, String table, Set<String> ids) async {
    if (ids.isEmpty) return;
    final placeholders = List.filled(ids.length, '?').join(',');
    await txn.delete(table,
        where: 'id IN ($placeholders)', whereArgs: ids.toList());
  }

  /// Deletes rows from [table] whose [parentColumn] is in [parentIds] — for
  /// clearing a parent's stale children before reinserting the fresh set
  /// nested in a changed-item payload, and for cascading deletes of a
  /// removed parent's children.
  Future<void> deleteByParentIds(
    Transaction txn,
    String table,
    String parentColumn,
    Set<String> parentIds,
  ) async {
    if (parentIds.isEmpty) return;
    final placeholders = List.filled(parentIds.length, '?').join(',');
    await txn.delete(
      table,
      where: '$parentColumn IN ($placeholders)',
      whereArgs: parentIds.toList(),
    );
  }
}
