import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/book.dart';
import '../models/book_author.dart';
import '../models/book_chapter.dart';
import '../models/book_subchapter.dart';

class BookOfflineService {
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'books', version: 1).database;

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

    return bookRows.map((row) {
      final id = row['id'].toString();
      return Book.fromDb(row, authors: authorsByBook[id] ?? []);
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

    return Book.fromDb(rows.first, authors: authors);
  }

  Future<Book?> findPreviousBookByPosition(int position) async {
    final db = await _db;
    final rows = await db.query(
      'books',
      where: 'position < ?',
      whereArgs: [position],
      orderBy: 'position DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return findBookById(rows.first['id'].toString());
  }

  Future<Book?> findNextBookByPosition(int position) async {
    final db = await _db;
    final rows = await db.query(
      'books',
      where: 'position > ?',
      whereArgs: [position],
      orderBy: 'position ASC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return findBookById(rows.first['id'].toString());
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

  Future<BookChapter?> findPreviousChapter({
    required String bookId,
    required int position,
    bool includeSubchapters = false,
  }) async {
    final db = await _db;
    final rows = await db.query(
      'chapters',
      where: 'book_id = ? AND position < ?',
      whereArgs: [bookId, position],
      orderBy: 'position DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;

    if (!includeSubchapters) {
      return BookChapter.fromDb(rows.first);
    }

    final chapters = await queryChapters(
      bookId: bookId,
      position: rows.first['position'] as int,
      quantity: 1,
      includeSubchapters: true,
    );
    return chapters.isEmpty ? null : chapters.first;
  }

  Future<BookChapter?> findNextChapter({
    required String bookId,
    required int position,
    bool includeSubchapters = false,
  }) async {
    final db = await _db;
    final rows = await db.query(
      'chapters',
      where: 'book_id = ? AND position > ?',
      whereArgs: [bookId, position],
      orderBy: 'position ASC',
      limit: 1,
    );

    if (rows.isEmpty) return null;

    if (!includeSubchapters) {
      return BookChapter.fromDb(rows.first);
    }

    final chapters = await queryChapters(
      bookId: bookId,
      position: rows.first['position'] as int,
      quantity: 1,
      includeSubchapters: true,
    );
    return chapters.isEmpty ? null : chapters.first;
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
        createdAt: sub.createdAt,
        updatedAt: sub.updatedAt,
        chapter: chapter != null
            ? BookSubchapterParentChapter(
                id: chapter.id, position: chapter.position)
            : null,
      );
    }

    return sub;
  }

  Future<BookSubchapter?> findPreviousSubchapter({
    required String chapterId,
    required int position,
  }) async {
    final db = await _db;
    final rows = await db.query(
      'subchapters',
      where: 'chapter_id = ? AND position < ?',
      whereArgs: [chapterId, position],
      orderBy: 'position DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return BookSubchapter.fromDb(rows.first);
  }

  Future<BookSubchapter?> findNextSubchapter({
    required String chapterId,
    required int position,
  }) async {
    final db = await _db;
    final rows = await db.query(
      'subchapters',
      where: 'chapter_id = ? AND position > ?',
      whereArgs: [chapterId, position],
      orderBy: 'position ASC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return BookSubchapter.fromDb(rows.first);
  }

  // ───────────────────── Authors (for filter) ─────────────────────

  Future<BookAuthor?> findAuthorById(String id) async {
    final db = await _db;
    final rows = await db.query('authors', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return BookAuthor.fromDb(rows.first);
  }
}
