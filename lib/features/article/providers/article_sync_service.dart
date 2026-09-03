import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Article set into
/// the local `articles` SQLite database. See `OfflineSyncEngine` for the
/// general approach and `book_sync_service.dart` for the fully-detailed case.
class ArticleSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/articles/offline-sync', 'articles');
    final currentIds = await _engine.fetchOfflineIds('/articles/offline-ids');
    // Refreshed every pass, not just for authors whose content changed — see
    // OfflineSyncEngine.fetchAuthorPositions.
    final authorPositions =
        await _engine.fetchAuthorPositions('/articles/authors');

    final db =
        await OfflineDatabaseHelper(feature: 'articles', version: 3).database;
    final localIds = (await db.query('articles', columns: ['id']))
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
        'document_url': json['documentUrl'],
        'published': json['published'] == true ? 1 : 0,
        'published_at': json['publishedAt'],
        'position': json['position'],
        'article_author_id': authorId,
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
            .add({'article_id': id, 'article_category_id': catId});
      }
    }

    await _engine.runSync(
      feature: 'articles',
      version: 3,
      apply: (txn) async {
        await _engine.deleteByParentIds(
            txn, 'article_categorizations', 'article_id', idsToClearChildren);
        await _engine.deleteByIds(txn, 'articles', removedIds);

        await _engine.upsertRows(txn, 'articles', rows);
        await _engine.upsertRows(
            txn, 'article_authors', authorRows.values.toList());
        await _engine.updatePositions(txn, 'article_authors', authorPositions);
        await _engine.upsertRows(
            txn, 'article_categories', categoryRows.values.toList());
        await _engine.upsertRows(
            txn, 'article_categorizations', categorizationRows);
      },
    );

    await _engine.commitSince('articles', serverTime);
  }
}
