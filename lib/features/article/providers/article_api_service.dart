import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';
import '../models/article_subcategory.dart';

/// Dio-based service for fetching articles from the JSON:API backend.
class ArticleApiService {
  late final Dio _dio;

  ArticleApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── Articles ─────────────────────

  Future<List<ArticleItem>> fetchArticles({
    int page = 1,
    int perPage = 9,
    String? search,
    String? articleAuthorId,
    String? articleCategoryId,
    String? articleSubcategoryId,
    bool includeAuthor = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'published': true,
      if (includeAuthor) 'include': 'article-author',
      if (search != null && search.isNotEmpty) 'search': search,
      if (articleAuthorId != null) 'articleAuthorId': articleAuthorId,
      if (articleCategoryId != null) 'articleCategoryId': articleCategoryId,
      if (articleSubcategoryId != null)
        'articleSubcategoryId': articleSubcategoryId,
    };

    final response = await _dio.get('/articles', queryParameters: params);
    return _parseArticlesResponse(response.data);
  }

  Future<ArticleItem> fetchSingleArticle(String id,
      {bool includeAuthor = true}) async {
    final params = <String, dynamic>{
      if (includeAuthor) 'include': 'article-author',
    };
    final response = await _dio.get('/articles/$id', queryParameters: params);
    return _parseSingleArticleResponse(response.data);
  }

  Future<List<ArticleItem>> fetchArticlesByPosition({
    int quantity = 1,
    required int position,
    bool includeAuthor = true,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
      if (includeAuthor) 'include': 'article-author',
    };
    final response = await _dio.get('/articles', queryParameters: params);
    return _parseArticlesResponse(response.data);
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<ArticleAuthor>> fetchAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response =
        await _dio.get('/article_authors', queryParameters: params);
    return _parseAuthorsResponse(response.data);
  }

  Future<ArticleAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/article_authors/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return ArticleAuthor.fromJsonApi(data);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<ArticleCategory>> fetchCategories({
    int page = 1,
    int perPage = 16,
    String? search,
    bool includeSubcategories = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (includeSubcategories) 'include': 'article-subcategories',
    };
    final response =
        await _dio.get('/article_categories', queryParameters: params);
    return _parseCategoriesResponse(response.data);
  }

  Future<ArticleCategory> fetchCategory(String id) async {
    final response = await _dio.get('/article_categories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return ArticleCategory.fromJsonApi(data);
  }

  // ───────────────────── Subcategories ─────────────────────

  Future<ArticleSubcategory> fetchSubcategory(String id) async {
    final response = await _dio.get('/article_subcategories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return ArticleSubcategory.fromJsonApi(data);
  }

  // ═══════════════════════════════════════════════
  //  JSON:API Response Parsing
  // ═══════════════════════════════════════════════

  Map<String, Map<String, dynamic>> _buildIncludedMap(dynamic included) {
    final map = <String, Map<String, dynamic>>{};
    if (included is List) {
      for (final item in included) {
        final type = item['type']?.toString() ?? '';
        final id = item['id']?.toString() ?? '';
        map['$type:$id'] = item as Map<String, dynamic>;
      }
    }
    return map;
  }

  String? _resolveSingleRelId(Map<String, dynamic> resource, String relName) {
    final rels = resource['relationships'] as Map<String, dynamic>?;
    if (rels == null || !rels.containsKey(relName)) return null;
    final relData = rels[relName]['data'];
    if (relData is Map) return relData['id']?.toString();
    return null;
  }

  List<String> _resolveRelIds(Map<String, dynamic> resource, String relName) {
    final rels = resource['relationships'] as Map<String, dynamic>?;
    if (rels == null || !rels.containsKey(relName)) return [];
    final relData = rels[relName]['data'];
    if (relData is List) {
      return relData.map((r) => r['id'].toString()).toList();
    } else if (relData is Map) {
      return [relData['id'].toString()];
    }
    return [];
  }

  List<ArticleItem> _parseArticlesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final authorId = _resolveSingleRelId(resource, 'article-author');
      String? authorName;
      if (authorId != null) {
        final authorRes = included['article_authors:$authorId'];
        if (authorRes != null) {
          final attrs = authorRes['attributes'] as Map<String, dynamic>? ?? {};
          authorName = attrs['name'];
        }
      }
      return ArticleItem.fromJsonApi(resource, resolvedAuthorName: authorName);
    }).toList();
  }

  ArticleItem _parseSingleArticleResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final authorId = _resolveSingleRelId(resource, 'article-author');
    String? authorName;
    if (authorId != null) {
      final authorRes = included['article_authors:$authorId'];
      if (authorRes != null) {
        final attrs = authorRes['attributes'] as Map<String, dynamic>? ?? {};
        authorName = attrs['name'];
      }
    }
    return ArticleItem.fromJsonApi(resource, resolvedAuthorName: authorName);
  }

  List<ArticleAuthor> _parseAuthorsResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => ArticleAuthor.fromJsonApi(r)).toList();
  }

  List<ArticleCategory> _parseCategoriesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final subcatIds = _resolveRelIds(resource, 'article-subcategories');
      final subcategories = subcatIds
          .map((id) => included['article_subcategories:$id'])
          .where((s) => s != null)
          .map((s) => ArticleSubcategory.fromJsonApi(s!))
          .toList();

      return ArticleCategory.fromJsonApi(resource,
          resolvedSubcategories: subcategories);
    }).toList();
  }
}
