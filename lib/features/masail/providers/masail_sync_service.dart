import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Masail set into
/// the local `masails` SQLite database, and the shared "misc" Pages bucket
/// used by the "ask a question" screen. See `OfflineSyncEngine` for the
/// general approach and `book_sync_service.dart` for the fully-detailed case.
///
/// Pages don't have their own entry in `offlineDbPrefetchService`'s feature
/// list or push-trigger dispatch — the backend sends push notifications for
/// Page changes under the "masails" feature key too, so a Page-only edit
/// still reaches this sync via the same dispatch as a Masail edit.
class MasailSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    await _syncMasails();
    await _syncPages();
  }

  Future<void> _syncMasails() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/masail/offline-sync', 'masails');
    final currentIds = await _engine.fetchOfflineIds('/masail/offline-ids');
    // Refreshed every pass, not just for authors whose content changed — see
    // OfflineSyncEngine.fetchAuthorPositions.
    final authorPositions =
        await _engine.fetchAuthorPositions('/masail/authors');

    final db =
        await OfflineDatabaseHelper(feature: 'masails', version: 3).database;
    final localIds = (await db.query('masails', columns: ['id']))
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
        'question': json['question'],
        'answer': json['answer'],
        'language': json['language'] ?? 'bn',
        'has_audio': json['hasAudio'] == true ? 1 : 0,
        'audio_url': json['audioUrl'],
        'document_url': json['documentUrl'],
        'published': json['published'] == true ? 1 : 0,
        'published_at': json['publishedAt'],
        'position': json['position'],
        'masail_author_id': authorId,
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
        categorizationRows.add({'masail_id': id, 'masail_category_id': catId});
      }
    }

    await _engine.runSync(
      feature: 'masails',
      version: 3,
      apply: (txn) async {
        await _engine.deleteByParentIds(
            txn, 'masail_categorizations', 'masail_id', idsToClearChildren);
        await _engine.deleteByIds(txn, 'masails', removedIds);

        await _engine.upsertRows(txn, 'masails', rows);
        await _engine.upsertRows(
            txn, 'masail_authors', authorRows.values.toList());
        await _engine.updatePositions(txn, 'masail_authors', authorPositions);
        await _engine.upsertRows(
            txn, 'masail_categories', categoryRows.values.toList());
        await _engine.upsertRows(
            txn, 'masail_categorizations', categorizationRows);
      },
    );

    await _engine.commitSince('masails', serverTime);
  }

  Future<void> _syncPages() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/pages/offline-sync', 'pages');
    final currentIds = await _engine.fetchOfflineIds('/pages/offline-ids');

    final db =
        await OfflineDatabaseHelper(feature: 'misc', version: 2).database;
    final localIds = (await db.query('pages', columns: ['id']))
        .map((r) => r['id'].toString())
        .toSet();
    final removedIds = localIds.difference(currentIds);

    final rows = items.map<Map<String, dynamic>>((json) {
      return {
        'id': json['id'].toString(),
        'title': json['title'],
        'slug': json['slug'],
        'body': json['body'],
        'image_url': json['imageUrl'],
        'created_at': json['createdAt'],
        'updated_at': json['updatedAt'],
      };
    }).toList();

    await _engine.runSync(
      feature: 'misc',
      version: 2,
      apply: (txn) async {
        await _engine.deleteByIds(txn, 'pages', removedIds);
        await _engine.upsertRows(txn, 'pages', rows);
      },
    );

    await _engine.commitSince('pages', serverTime);
  }
}
