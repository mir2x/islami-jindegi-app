import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Malfuzat set into
/// the local `malfuzats` SQLite database. See `OfflineSyncEngine` for the
/// general approach and `book_sync_service.dart` for the fully-detailed case.
class MalfuzatSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/malfuzat/offline-sync', 'malfuzats');
    final currentIds = await _engine.fetchOfflineIds('/malfuzat/offline-ids');
    // Refreshed every pass, not just for authors whose content changed — see
    // OfflineSyncEngine.fetchAuthorPositions.
    final authorPositions =
        await _engine.fetchAuthorPositions('/malfuzat/authors');

    final db =
        await OfflineDatabaseHelper(feature: 'malfuzats', version: 3).database;
    final localIds = (await db.query('malfuzats', columns: ['id']))
        .map((r) => r['id'].toString())
        .toSet();
    final removedIds = localIds.difference(currentIds);
    final changedIds =
        items.map<String>((json) => json['id'].toString()).toSet();
    final idsToClearChildren = changedIds.union(removedIds);

    final rows = <Map<String, dynamic>>[];
    final authorRows = <String, Map<String, dynamic>>{};
    final categoryRows = <String, Map<String, dynamic>>{};
    final categorizationRows = <Map<String, dynamic>>[];

    for (final json in items) {
      final id = json['id'].toString();
      final author = json['author'] as Map<String, dynamic>?;
      final authorId = author?['id']?.toString();

      rows.add({
        'id': id,
        'title': json['title'] ?? '',
        'body': json['body'],
        'excerpt': json['excerpt'],
        'language': json['language'] ?? 'bn',
        'has_audio': json['hasAudio'] == true ? 1 : 0,
        'audio_url': json['audioUrl'],
        'document_url': json['documentUrl'],
        'published': json['published'] == true ? 1 : 0,
        'published_at': json['publishedAt'],
        'position': json['position'],
        'malfuzat_author_id': authorId,
        'created_at': json['createdAt'],
        'updated_at': json['updatedAt'],
      });

      if (author != null && authorId != null) {
        authorRows[authorId] = {
          'id': authorId,
          'name': author['name'] ?? '',
          'info': author['info'],
          'position': author['position'],
        };
      }

      for (final cat in (json['categories'] as List? ?? [])) {
        final catId = cat['id'].toString();
        categoryRows[catId] = {
          'id': catId,
          'title': cat['title'] ?? '',
          'position': cat['position'],
        };
        categorizationRows
            .add({'malfuzat_id': id, 'malfuzat_category_id': catId});
      }
    }

    await _engine.runSync(
      feature: 'malfuzats',
      version: 3,
      apply: (txn) async {
        await _engine.deleteByParentIds(
            txn, 'malfuzat_categorizations', 'malfuzat_id', idsToClearChildren);
        await _engine.deleteByIds(txn, 'malfuzats', removedIds);

        await _engine.upsertRows(txn, 'malfuzats', rows);
        await _engine.upsertRows(
            txn, 'malfuzat_authors', authorRows.values.toList());
        await _engine.updatePositions(txn, 'malfuzat_authors', authorPositions);
        await _engine.upsertRows(
            txn, 'malfuzat_categories', categoryRows.values.toList());
        await _engine.upsertRows(
            txn, 'malfuzat_categorizations', categorizationRows);
      },
    );

    await _engine.commitSince('malfuzats', serverTime);
  }
}
