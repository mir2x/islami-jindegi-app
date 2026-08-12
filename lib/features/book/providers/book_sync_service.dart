import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';

/// Incrementally syncs the admin-curated offline-available Book set into the
/// local `books` SQLite database, including nested chapters/subchapters/
/// authors, and caches each book's cover image locally so it renders without
/// network access. See `OfflineSyncEngine` for the general sync approach.
///
/// Book is the only one of the 8 offline domains with two levels of nesting
/// (chapters -> subchapters) and a genuine "cover image" field, so it's the
/// most involved of the per-domain sync services — the others follow the
/// same shape with one less nesting level and no file caching.
class BookSyncService {
  final OfflineSyncEngine _engine = OfflineSyncEngine();

  Future<void> sync() async {
    final (items, serverTime) =
        await _engine.fetchChangedSet('/books/offline-sync', 'books');
    final currentIds = await _engine.fetchOfflineIds('/books/offline-ids');

    final db =
        await OfflineDatabaseHelper(feature: 'books', version: 3).database;

    final existingRows = await db
        .query('books', columns: ['id', 'updated_at', 'cover_image_path']);
    final existingById = {
      for (final row in existingRows) row['id'].toString(): row
    };
    final localIds = existingById.keys.toSet();

    final changedIds =
        items.map<String>((json) => json['id'].toString()).toSet();
    final removedIds = localIds.difference(currentIds);
    // Books whose children need clearing before this pass' fresh nested data
    // (if any) is inserted — both "changed" (full current children coming)
    // and "removed" (no replacement coming) books need their old children wiped.
    final idsToClearChildren = changedIds.union(removedIds);

    final imagesDir = Directory(p.join(
      (await getApplicationDocumentsDirectory()).path,
      'offline_images',
      'books',
    ));
    await imagesDir.create(recursive: true);

    final bookRows = <Map<String, dynamic>>[];
    final chapterRows = <Map<String, dynamic>>[];
    final subchapterRows = <Map<String, dynamic>>[];
    final authorRows = <String, Map<String, dynamic>>{};
    final booksAuthorsRows = <Map<String, dynamic>>[];

    for (final json in items) {
      final id = json['id'].toString();
      final coverUrl = json['coverUrl'] as String?;
      final updatedAt = json['updatedAt'] as String?;
      final prior = existingById[id];
      final coverPath = await _resolveCoverPath(
        imagesDir: imagesDir,
        id: id,
        coverUrl: coverUrl,
        updatedAt: updatedAt,
        priorUpdatedAt: prior?['updated_at'] as String?,
        priorPath: prior?['cover_image_path'] as String?,
      );

      bookRows.add({
        'id': id,
        'title': json['title'] ?? '',
        'excerpt': json['excerpt'],
        'publisher': json['publisher'],
        'price': json['price'],
        'language': json['language'] ?? '',
        'cover_url': coverUrl,
        'document_url': json['documentUrl'],
        'position': json['position'],
        'published': json['published'] == true ? 1 : 0,
        'published_at': json['publishedAt'],
        'cover_image_path': coverPath,
        'created_at': json['createdAt'],
        'updated_at': updatedAt,
      });

      for (final author in (json['authors'] as List? ?? [])) {
        final authorId = author['id'].toString();
        authorRows[authorId] = {
          'id': authorId,
          'name': author['name'] ?? '',
          'info': author['info'],
          'position': author['position'],
        };
        booksAuthorsRows.add({'book_id': id, 'author_id': authorId});
      }

      for (final chapter in (json['chapters'] as List? ?? [])) {
        final chapterId = chapter['id'].toString();
        chapterRows.add({
          'id': chapterId,
          'book_id': id,
          'title': chapter['title'] ?? '',
          'body': chapter['body'],
          'position': chapter['position'],
        });

        for (final sub in (chapter['subChapters'] as List? ?? [])) {
          subchapterRows.add({
            'id': sub['id'].toString(),
            'chapter_id': chapterId,
            'title': sub['title'] ?? '',
            'body': sub['body'],
            'position': sub['position'],
          });
        }
      }
    }

    // Drop cached cover files for books that fell out of the offline set.
    for (final removedId in removedIds) {
      final path = existingById[removedId]?['cover_image_path'] as String?;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) await file.delete();
      }
    }

    await db.transaction((txn) async {
      // Clear stale children before inserting the fresh set — subchapters
      // first, since they're only reachable via chapter_id, not book_id.
      await txn.rawDelete(
        'DELETE FROM subchapters WHERE chapter_id IN '
        '(SELECT id FROM chapters WHERE book_id IN '
        '(${List.filled(idsToClearChildren.length, '?').join(',')}))',
        idsToClearChildren.toList(),
      );
      await _engine.deleteByParentIds(
          txn, 'chapters', 'book_id', idsToClearChildren);
      await _engine.deleteByParentIds(
          txn, 'books_authors', 'book_id', idsToClearChildren);
      await _engine.deleteByIds(txn, 'books', removedIds);

      await _engine.upsertRows(txn, 'books', bookRows);
      await _engine.upsertRows(txn, 'authors', authorRows.values.toList());
      await _engine.upsertRows(txn, 'chapters', chapterRows);
      await _engine.upsertRows(txn, 'subchapters', subchapterRows);
      await _engine.upsertRows(txn, 'books_authors', booksAuthorsRows);
    });

    await _engine.commitSince('books', serverTime);
  }

  /// Downloads [coverUrl] to disk only when needed (missing locally, or the
  /// book changed since the last sync); otherwise reuses the existing path.
  Future<String?> _resolveCoverPath({
    required Directory imagesDir,
    required String id,
    required String? coverUrl,
    required String? updatedAt,
    required String? priorUpdatedAt,
    required String? priorPath,
  }) async {
    if (coverUrl == null || coverUrl.isEmpty) return null;

    final ext = p.extension(Uri.parse(coverUrl).path);
    final localPath =
        p.join(imagesDir.path, '$id${ext.isNotEmpty ? ext : '.jpg'}');
    final localFile = File(localPath);

    final upToDate = priorPath == localPath &&
        priorUpdatedAt == updatedAt &&
        await localFile.exists();
    if (upToDate) return localPath;

    try {
      await _engine.downloadFile(coverUrl, localPath);
      return localPath;
    } catch (_) {
      // Network hiccup on a single cover shouldn't fail the whole sync —
      // fall back to whatever was cached before, or no local cover at all.
      return (priorPath != null && await File(priorPath).exists())
          ? priorPath
          : null;
    }
  }
}
