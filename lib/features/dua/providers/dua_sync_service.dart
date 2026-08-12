import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Dua set into the
/// local `duas` SQLite database. See `OfflineSyncEngine` for the general
/// approach and `book_sync_service.dart` for the fully-detailed case.
class DuaSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/dua/offline-sync', 'duas');
    final currentIds = await _engine.fetchOfflineIds('/dua/offline-ids');

    final db =
        await OfflineDatabaseHelper(feature: 'duas', version: 3).database;
    final localIds = (await db.query('duas', columns: ['id']))
        .map((r) => r['id'].toString())
        .toSet();
    final removedIds = localIds.difference(currentIds);
    final changedIds =
        items.map<String>((json) => json['id'].toString()).toSet();
    final idsToClearChildren = changedIds.union(removedIds);

    final duaRows = <Map<String, dynamic>>[];
    final categoryRows = <String, Map<String, dynamic>>{};
    final categorizationRows = <Map<String, dynamic>>[];

    for (final json in items) {
      final id = json['id'].toString();
      duaRows.add({
        'id': id,
        'title': json['title'] ?? '',
        'body': json['body'],
        'excerpt': json['excerpt'],
        'language': json['language'] ?? 'bn',
        'audio_url': json['audioUrl'],
        'document_url': json['documentUrl'],
        'published': json['published'] == true ? 1 : 0,
        'position': json['position'],
        'created_at': json['createdAt'],
        'updated_at': json['updatedAt'],
      });

      for (final cat in (json['categories'] as List? ?? [])) {
        final catId = cat['id'].toString();
        categoryRows[catId] = {
          'id': catId,
          'title': cat['title'] ?? '',
          'position': cat['position'],
        };
        categorizationRows.add({'dua_id': id, 'dua_category_id': catId});
      }
    }

    await _engine.runSync(
      feature: 'duas',
      version: 3,
      apply: (txn) async {
        await _engine.deleteByParentIds(
            txn, 'dua_categorizations', 'dua_id', idsToClearChildren);
        await _engine.deleteByIds(txn, 'duas', removedIds);

        await _engine.upsertRows(txn, 'duas', duaRows);
        await _engine.upsertRows(
            txn, 'dua_categories', categoryRows.values.toList());
        await _engine.upsertRows(
            txn, 'dua_categorizations', categorizationRows);
      },
    );

    await _engine.commitSince('duas', serverTime);
  }
}
