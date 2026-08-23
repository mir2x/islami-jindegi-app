import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../../core/services/offline_sync_engine.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../../../core/utils/offline_storage.dart';

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
        await OfflineDatabaseHelper(feature: 'books', version: 4).database;

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

    final imagesDir = await OfflineStorage.imagesDir('books');

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
      final coverFile = await _resolveCoverFile(
        imagesDir: imagesDir,
        id: id,
        coverUrl: coverUrl,
        updatedAt: updatedAt,
        priorUpdatedAt: prior?['updated_at'] as String?,
        priorFile: prior?['cover_image_path'] as String?,
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
        'cover_image_path': coverFile,
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
          'reading_order': chapter['readingOrder'],
        });

        for (final sub in (chapter['subChapters'] as List? ?? [])) {
          subchapterRows.add({
            'id': sub['id'].toString(),
            'chapter_id': chapterId,
            'title': sub['title'] ?? '',
            'body': sub['body'],
            'position': sub['position'],
            'parent_subchapter_id': sub['parentSubChapterId'],
            'reading_order': sub['readingOrder'],
          });
        }
      }
    }

    // Drop cached cover files for books that fell out of the offline set.
    for (final removedId in removedIds) {
      final name = existingById[removedId]?['cover_image_path'] as String?;
      final path = OfflineStorage.resolve(name, imagesDir.path);
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

    // Must run before the watermark moves: once it advances, books whose
    // cover failed here drop out of the changed set and are never revisited.
    await _repairMissingCovers(db, imagesDir);

    await _engine.commitSince('books', serverTime);
  }

  /// Re-downloads covers for books whose cached file is missing.
  ///
  /// Covers this pass' failures (a download that threw is stored as a null
  /// path) and every earlier pass' too, plus files lost to an iOS container
  /// change or manual storage clearing. Without it a single failed download
  /// is permanent: the book only reappears in `/books/offline-sync` when an
  /// admin edits it, so nothing would ever retry.
  Future<void> _repairMissingCovers(Database db, Directory imagesDir) async {
    final rows = await db.query(
      'books',
      columns: ['id', 'cover_url', 'cover_image_path'],
      where: "cover_url IS NOT NULL AND cover_url != ''",
    );

    for (final row in rows) {
      final name = row['cover_image_path'] as String?;
      final path = OfflineStorage.resolve(name, imagesDir.path);
      if (path != null && await File(path).exists()) continue;

      final id = row['id'].toString();
      final fileName = await _downloadCover(
        imagesDir: imagesDir,
        id: id,
        coverUrl: row['cover_url'] as String,
      );
      if (fileName == null) continue;

      await db.update(
        'books',
        {'cover_image_path': fileName},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  /// Downloads [coverUrl] only when needed (nothing cached locally, or the
  /// book changed since the last sync); otherwise reuses the cached file.
  ///
  /// Returns the *file name*, not a full path — see [OfflineStorage] for why
  /// absolute paths must not be persisted.
  Future<String?> _resolveCoverFile({
    required Directory imagesDir,
    required String id,
    required String? coverUrl,
    required String? updatedAt,
    required String? priorUpdatedAt,
    required String? priorFile,
  }) async {
    if (coverUrl == null || coverUrl.isEmpty) return null;

    final fileName = _coverFileName(id, coverUrl);
    final priorPath = OfflineStorage.resolve(priorFile, imagesDir.path);

    final upToDate = priorFile == fileName &&
        priorUpdatedAt == updatedAt &&
        priorPath != null &&
        await File(priorPath).exists();
    if (upToDate) return fileName;

    final downloaded =
        await _downloadCover(imagesDir: imagesDir, id: id, coverUrl: coverUrl);
    if (downloaded != null) return downloaded;

    // Network hiccup on a single cover shouldn't fail the whole sync — keep
    // whatever was cached before, and let `_repairMissingCovers` retry on a
    // later pass when there's nothing to fall back to.
    return (priorPath != null && await File(priorPath).exists())
        ? priorFile
        : null;
  }

  /// Fetches one cover into [imagesDir], returning its file name or null if
  /// the download failed. Dio deletes the partial file on error, so a failure
  /// never leaves a truncated image behind.
  Future<String?> _downloadCover({
    required Directory imagesDir,
    required String id,
    required String coverUrl,
  }) async {
    final fileName = _coverFileName(id, coverUrl);
    try {
      await _engine.downloadFile(coverUrl, p.join(imagesDir.path, fileName));
      return fileName;
    } catch (_) {
      return null;
    }
  }

  String _coverFileName(String id, String coverUrl) {
    final ext = p.extension(Uri.parse(coverUrl).path);
    return '$id${ext.isNotEmpty ? ext : '.jpg'}';
  }
}
