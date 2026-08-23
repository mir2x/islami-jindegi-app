import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../../../core/utils/offline_storage.dart';
import '../models/book.dart';
import '../models/book_author.dart';
import '../models/book_chapter.dart';
import '../models/book_subchapter.dart';
import '../models/book_node_ref.dart';

class BookOfflineService {
  // Bumped 1 -> 2 for Guid ids, then 2 -> 3 for the move from a prebuilt
  // downloaded file to an admin-curated, client-created-and-synced schema
  // (see OfflineDatabaseHelper / BookSyncService) — existing installs must
  // rebuild their local schema and re-sync from the offline-sync endpoint.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'books', version: 4).database;
  Future<Database> get database => _db;

  Future<BookNodeRef?> findBookNodeSibling({
    required String bookId,
    required int readingOrder,
    required bool forward,
  }) async {
    final db = await _db;
    final comparison = forward ? '>' : '<';
    final direction = forward ? 'ASC' : 'DESC';
    final rows = await db.rawQuery('''
      SELECT id, title, reading_order, 'chapter' AS kind
      FROM chapters
      WHERE book_id = ? AND reading_order IS NOT NULL AND reading_order $comparison ?
      UNION ALL
      SELECT s.id, s.title, s.reading_order, 'subchapter' AS kind
      FROM subchapters s INNER JOIN chapters c ON c.id = s.chapter_id
      WHERE c.book_id = ? AND s.reading_order $comparison ?
      ORDER BY reading_order $direction LIMIT 1
    ''', [bookId, readingOrder, bookId, readingOrder]);
    if (rows.isEmpty) return null;
    final row = rows.first;
    return BookNodeRef(
        id: row['id'].toString(),
        title: row['title']?.toString() ?? '',
        readingOrder: row['reading_order'] as int,
        kind: row['kind'].toString());
  }

  /// Where cached covers live right now. Resolved per read because the iOS
  /// app container path changes across updates (see `OfflineStorage`).
  Future<String> get _imagesDirPath => OfflineStorage.imagesDirPath('books');

  // ───────────────────── Books ─────────────────────

  Future<List<Book>> queryBooks({
    int? page,
    int? perPage,
    int? position,
    int? quantity,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <dynamic>[];

    if (position != null) {
      where.add('position = ?');
      args.add(position);
    }

    int limit = quantity ?? perPage ?? 20;
    int offset = 0;
    if (page != null && perPage != null) {
      offset = (page - 1) * perPage;
    }

    final bookRows = await db.query(
      'books',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: limit,
      offset: offset,
    );

    if (bookRows.isEmpty) return [];

    // Resolve authors via join table
    final bookIds = bookRows.map((r) => r['id'].toString()).toList();
    final placeholders = List.filled(bookIds.length, '?').join(',');

    final authorJoins = await db.rawQuery('''
      SELECT ba.book_id, a.*
      FROM books_authors ba
      INNER JOIN authors a ON a.id = ba.author_id
      WHERE ba.book_id IN ($placeholders)
    ''', bookIds);

    final authorsByBook = <String, List<BookAuthor>>{};
    for (final row in authorJoins) {
      final bookId = row['book_id'].toString();
      authorsByBook.putIfAbsent(bookId, () => []).add(BookAuthor.fromDb(row));
    }

    final imagesDirPath = await _imagesDirPath;
    return bookRows.map((row) {
      final id = row['id'].toString();
      return Book.fromDb(
        row,
        authors: authorsByBook[id] ?? [],
        imagesDirPath: imagesDirPath,
      );
    }).toList();
  }

  Future<Book?> findBookById(String id, {bool includeAuthors = true}) async {
    final db = await _db;
    final rows = await db.query('books', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    List<BookAuthor> authors = [];
    if (includeAuthors) {
      final authorJoins = await db.rawQuery('''
        SELECT a.*
        FROM books_authors ba
        INNER JOIN authors a ON a.id = ba.author_id
        WHERE ba.book_id = ?
      ''', [id]);
      authors = authorJoins.map((r) => BookAuthor.fromDb(r)).toList();
    }

    return Book.fromDb(
      rows.first,
      authors: authors,
      imagesDirPath: await _imagesDirPath,
    );
  }

  // ───────────────────── Chapters ─────────────────────

  Future<List<BookChapter>> queryChapters({
    required String bookId,
    int? quantity,
    int? position,
    String? sort,
    bool includeSubchapters = false,
  }) async {
    final db = await _db;
    final where = <String>['book_id = ?'];
    final args = <dynamic>[bookId];

    if (position != null) {
      where.add('position = ?');
      args.add(position);
    }

    String orderBy = 'position ASC';
    if (sort == '-position') {
      orderBy = 'position DESC';
    }

    final chapterRows = await db.query(
      'chapters',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: orderBy,
      limit: quantity ?? 200,
    );

    if (!includeSubchapters || chapterRows.isEmpty) {
      return chapterRows.map((r) => BookChapter.fromDb(r)).toList();
    }

    // Fetch subchapters for all chapters at once
    final chapterIds = chapterRows.map((r) => r['id'].toString()).toList();
    final placeholders = List.filled(chapterIds.length, '?').join(',');
    final subchapterRows = await db.query(
      'subchapters',
      where: 'chapter_id IN ($placeholders)',
      whereArgs: chapterIds,
      orderBy: 'position ASC',
    );

    final subchaptersByChapter = <String, List<BookSubchapter>>{};
    for (final row in subchapterRows) {
      final chapterId = row['chapter_id'].toString();
      subchaptersByChapter
          .putIfAbsent(chapterId, () => [])
          .add(BookSubchapter.fromDb(row));
    }

    return chapterRows.map((row) {
      final id = row['id'].toString();
      return BookChapter.fromDb(row,
          subchapters: subchaptersByChapter[id] ?? []);
    }).toList();
  }

  Future<BookChapter?> findChapterById(String id) async {
    final db = await _db;
    final rows = await db.query('chapters', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return BookChapter.fromDb(rows.first);
  }

  // ───────────────────── Subchapters ─────────────────────

  Future<List<BookSubchapter>> querySubchapters({
    required String chapterId,
    int? quantity,
    int? position,
  }) async {
    final db = await _db;
    final where = <String>['chapter_id = ?'];
    final args = <dynamic>[chapterId];

    if (position != null) {
      where.add('position = ?');
      args.add(position);
    }

    final rows = await db.query(
      'subchapters',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position ASC',
      limit: quantity ?? 200,
    );

    return rows.map((r) => BookSubchapter.fromDb(r)).toList();
  }

  Future<BookSubchapter?> findSubchapterById(String id,
      {bool includeChapter = false}) async {
    final db = await _db;
    final rows =
        await db.query('subchapters', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final sub = BookSubchapter.fromDb(rows.first);

    if (includeChapter && sub.chapterId != null) {
      final chapter = await findChapterById(sub.chapterId!);
      return BookSubchapter(
        id: sub.id,
        title: sub.title,
        body: sub.body,
        position: sub.position,
        chapterId: sub.chapterId,
        chapterTitle: chapter?.title,
      );
    }

    return sub;
  }

  // ───────────────────── Authors (for filter) ─────────────────────

  Future<BookAuthor?> findAuthorById(String id) async {
    final db = await _db;
    final rows = await db.query('authors', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return BookAuthor.fromDb(rows.first);
  }
}
