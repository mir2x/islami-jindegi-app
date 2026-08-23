import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';

class ArticleOfflineService {
  // Bumped 1 -> 2 for Guid ids, then 2 -> 3 for the move from a prebuilt
  // downloaded file to an admin-curated, client-created-and-synced schema
  // (see OfflineDatabaseHelper / ArticleSyncService) — existing installs
  // must rebuild their local schema and re-sync from the offline-sync
  // endpoint.
  Future<Database> get _db =>
      OfflineDatabaseHelper(feature: 'articles', version: 3).database;

  // ───────────────────── Articles ─────────────────────

  Future<List<ArticleItem>> queryArticles({
    int page = 1,
    int perPage = 9,
    String? search,
    String? articleAuthorId,
    String? articleCategoryId,
    String? dateFrom,
    String? dateTo,
  }) async {
    final db = await _db;
    final where = <String>['published = 1'];
    final args = <dynamic>[];

    if (articleAuthorId != null) {
      where.add('article_author_id = ?');
      args.add(articleAuthorId);
    }
    if (articleCategoryId != null) {
      where.add(
          'id IN (SELECT article_id FROM article_categorizations WHERE article_category_id = ?)');
      args.add(articleCategoryId);
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    // Dates are stored as the API's ISO-8601 strings, so comparing the day
    // prefix keeps the bounds inclusive whatever time component came with them.
    // `published_at` is null for most content carried over from the legacy
    // backend, which kept only a creation date — the same fallback the API
    // applies, so online and offline results match.
    if (dateFrom != null && dateFrom.isNotEmpty) {
      where.add('substr(COALESCE(published_at, created_at), 1, 10) >= ?');
      args.add(dateFrom);
    }
    if (dateTo != null && dateTo.isNotEmpty) {
      where.add('substr(COALESCE(published_at, created_at), 1, 10) <= ?');
      args.add(dateTo);
    }

    final rows = await db.query(
      'articles',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position DESC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );

    if (rows.isEmpty) return [];

    // Resolve author names
    final authorIds = rows
        .map((r) => r['article_author_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    final authorNames = <String, String>{};
    if (authorIds.isNotEmpty) {
      final ph = List.filled(authorIds.length, '?').join(',');
      final authorRows = await db
          .rawQuery('SELECT id, name FROM article_authors WHERE id IN ($ph)', authorIds);
      for (final r in authorRows) {
        authorNames[r['id'].toString()] = r['name'].toString();
      }
    }

    return rows.map((row) {
      final authorId = row['article_author_id']?.toString();
      return ArticleItem.fromDb(row,
          authorName: authorId != null ? authorNames[authorId] : null);
    }).toList();
  }

  Future<ArticleItem?> findArticleById(String id) async {
    final db = await _db;
    final rows =
        await db.query('articles', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final row = rows.first;
    String? authorName;
    final authorId = row['article_author_id']?.toString();
    if (authorId != null) {
      final aRows = await db
          .query('article_authors', where: 'id = ?', whereArgs: [authorId]);
      if (aRows.isNotEmpty) authorName = aRows.first['name']?.toString();
    }
    return ArticleItem.fromDb(row, authorName: authorName);
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<ArticleAuthor>> queryAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      where.add('name LIKE ?');
      args.add('%$search%');
    }

    final rows = await db.query(
      'article_authors',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => ArticleAuthor.fromDb(r)).toList();
  }

  Future<ArticleAuthor?> findAuthorById(String id) async {
    final db = await _db;
    final rows =
        await db.query('article_authors', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ArticleAuthor.fromDb(rows.first);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<ArticleCategory>> queryCategories({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      where.add('title LIKE ?');
      args.add('%$search%');
    }

    final rows = await db.query(
      'article_categories',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    return rows.map((r) => ArticleCategory.fromDb(r)).toList();
  }

  Future<ArticleCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('article_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ArticleCategory.fromDb(rows.first);
  }
}
