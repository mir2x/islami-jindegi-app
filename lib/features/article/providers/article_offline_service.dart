import 'package:sqflite/sqflite.dart';
import '../../../core/utils/offline_database_helper.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';
import '../models/article_subcategory.dart';

class ArticleOfflineService {
  Future<Database> get _db => OfflineDatabaseHelper().database;

  // ───────────────────── Articles ─────────────────────

  Future<List<ArticleItem>> queryArticles({
    int page = 1,
    int perPage = 9,
    String? search,
    String? articleAuthorId,
    String? articleCategoryId,
    String? articleSubcategoryId,
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
    if (articleSubcategoryId != null) {
      where.add(
          'id IN (SELECT article_id FROM article_subcategorizations WHERE article_subcategory_id = ?)');
      args.add(articleSubcategoryId);
    }
    if (search != null && search.isNotEmpty) {
      where.add('(title LIKE ? OR excerpt LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    final rows = await db.query(
      'articles',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'position ASC',
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

    final catRows = await db.query(
      'article_categories',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'position ASC',
      limit: perPage,
      offset: (page - 1) * perPage,
    );
    if (catRows.isEmpty) return [];

    final catIds = catRows.map((r) => r['id'].toString()).toList();
    final ph = List.filled(catIds.length, '?').join(',');
    final subRows = await db.query(
      'article_subcategories',
      where: 'article_category_id IN ($ph)',
      whereArgs: catIds,
      orderBy: 'position ASC',
    );

    final subsByCat = <String, List<ArticleSubcategory>>{};
    for (final r in subRows) {
      final catId = r['article_category_id'].toString();
      subsByCat.putIfAbsent(catId, () => []).add(ArticleSubcategory.fromDb(r));
    }

    return catRows.map((row) {
      final id = row['id'].toString();
      return ArticleCategory.fromDb(row, subcategories: subsByCat[id] ?? []);
    }).toList();
  }

  Future<ArticleCategory?> findCategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('article_categories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final subRows = await db.query('article_subcategories',
        where: 'article_category_id = ?', whereArgs: [id], orderBy: 'position ASC');
    final subs = subRows.map((r) => ArticleSubcategory.fromDb(r)).toList();
    return ArticleCategory.fromDb(rows.first, subcategories: subs);
  }

  Future<ArticleSubcategory?> findSubcategoryById(String id) async {
    final db = await _db;
    final rows = await db
        .query('article_subcategories', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ArticleSubcategory.fromDb(rows.first);
  }
}
