import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Bayan set into
/// the local `bayans` SQLite database. See `OfflineSyncEngine` for the
/// general approach and `book_sync_service.dart` for the fully-detailed case.
///
/// The API's `author` field is stored locally as `speakers`, matching the
/// existing bayan-domain naming used by `bayan_offline_service.dart`.
class BayanSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/bayan/offline-sync', 'bayans');
    final currentIds = await _engine.fetchOfflineIds('/bayan/offline-ids');

    final db =
        await OfflineDatabaseHelper(feature: 'bayans', version: 3).database;
    final localIds = (await db.query('bayans', columns: ['id']))
        .map((r) => r['id'].toString())
        .toSet();
    final removedIds = localIds.difference(currentIds);
    final changedIds =
        items.map<String>((json) => json['id'].toString()).toSet();
    final idsToClearChildren = changedIds.union(removedIds);

    final rows = <Map<String, dynamic>>[];
    final speakerRows = <String, Map<String, dynamic>>{};
    final categoryRows = <String, Map<String, dynamic>>{};
    final categorizationRows = <Map<String, dynamic>>[];

    for (final json in items) {
      final id = json['id'].toString();
      final speaker = json['author'] as Map<String, dynamic>?;
      final speakerId = speaker?['id']?.toString();

      rows.add({
        'id': id,
        'title': json['title'] ?? '',
        'excerpt': json['excerpt'],
        'language': json['language'] ?? 'bn',
        'location': json['location'],
        'audio_url': json['audioUrl'],
        'published': json['published'] == true ? 1 : 0,
        'published_at': json['publishedAt'],
        'position': json['position'],
        'speaker_id': speakerId,
        'created_at': json['createdAt'],
        'updated_at': json['updatedAt'],
      });

      if (speaker != null && speakerId != null) {
        speakerRows[speakerId] = {
          'id': speakerId,
          'name': speaker['name'] ?? '',
          'info': speaker['info'],
          'position': speaker['position'],
        };
      }

      for (final cat in (json['categories'] as List? ?? [])) {
        final catId = cat['id'].toString();
        categoryRows[catId] = {
          'id': catId,
          'title': cat['title'] ?? '',
          'position': cat['position'],
        };
        categorizationRows.add({'bayan_id': id, 'bayan_category_id': catId});
      }
    }

    await _engine.runSync(
      feature: 'bayans',
      version: 3,
      apply: (txn) async {
        await _engine.deleteByParentIds(
            txn, 'bayan_categorizations', 'bayan_id', idsToClearChildren);
        await _engine.deleteByIds(txn, 'bayans', removedIds);

        await _engine.upsertRows(txn, 'bayans', rows);
        await _engine.upsertRows(txn, 'speakers', speakerRows.values.toList());
        await _engine.upsertRows(
            txn, 'bayan_categories', categoryRows.values.toList());
        await _engine.upsertRows(
            txn, 'bayan_categorizations', categorizationRows);
      },
    );

    await _engine.commitSince('bayans', serverTime);
  }
}
