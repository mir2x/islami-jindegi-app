import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Madrasah set into
/// the local `madrasahs` SQLite database, including each madrasah's nested
/// info fields and photo gallery. See `OfflineSyncEngine` for the general
/// approach and `book_sync_service.dart` for the fully-detailed case.
///
/// The backend regenerates every Info/Photo row (with new ids) on each
/// Madrasah update rather than diffing them, so — like Book's chapters —
/// a changed madrasah's old children must be cleared before the fresh set
/// is inserted, otherwise stale rows with orphaned ids would accumulate.
class MadrasahSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/madrasahs/offline-sync', 'madrasahs');
    final currentIds = await _engine.fetchOfflineIds('/madrasahs/offline-ids');

    final db =
        await OfflineDatabaseHelper(feature: 'madrasahs', version: 3).database;
    final localIds = (await db.query('madrasahs', columns: ['id']))
        .map((r) => r['id'].toString())
        .toSet();
    final removedIds = localIds.difference(currentIds);
    final changedIds =
        items.map<String>((json) => json['id'].toString()).toSet();
    final idsToClearChildren = changedIds.union(removedIds);

    final rows = <Map<String, dynamic>>[];
    final infoRows = <Map<String, dynamic>>[];
    final photoRows = <Map<String, dynamic>>[];

    for (final json in items) {
      final id = json['id'].toString();

      rows.add({
        'id': id,
        'title': json['title'] ?? '',
        'excerpt': json['excerpt'],
        'introduction': json['introduction'] ?? '',
        'position': json['position'],
        'created_at': json['createdAt'],
        'updated_at': json['updatedAt'],
      });

      for (final info in (json['infos'] as List? ?? [])) {
        infoRows.add({
          'id': info['id'].toString(),
          'madrasah_id': id,
          'label': info['label'],
          'info': info['info'],
          'position': info['position'],
        });
      }

      for (final photo in (json['photos'] as List? ?? [])) {
        photoRows.add({
          'id': photo['id'].toString(),
          'madrasah_id': id,
          'title': photo['title'],
          'image_url': photo['imageUrl'],
          'position': photo['position'],
        });
      }
    }

    await _engine.runSync(
      feature: 'madrasahs',
      version: 3,
      apply: (txn) async {
        await _engine.deleteByParentIds(
            txn, 'madrasah_infos', 'madrasah_id', idsToClearChildren);
        await _engine.deleteByParentIds(
            txn, 'madrasah_photos', 'madrasah_id', idsToClearChildren);
        await _engine.deleteByIds(txn, 'madrasahs', removedIds);

        await _engine.upsertRows(txn, 'madrasahs', rows);
        await _engine.upsertRows(txn, 'madrasah_infos', infoRows);
        await _engine.upsertRows(txn, 'madrasah_photos', photoRows);
      },
    );

    await _engine.commitSince('madrasahs', serverTime);
  }
}
