import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';

/// Dio-based service for fetching articles from the .NET API (plain JSON).
class ArticleApiService {
  late final Dio _dio;

  ArticleApiService() {
    final baseUrl = '${dotenv.env['DOTNET_API_HOST_NAME']}/api';
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  // ───────────────────── Articles ─────────────────────

  Future<List<ArticleItem>> fetchArticles({
    int page = 1,
    int perPage = 9,
    String? search,
    String? articleAuthorId,
    String? articleCategoryId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (articleAuthorId != null) 'authorId': articleAuthorId,
      if (articleCategoryId != null) 'categoryId': articleCategoryId,
    };

    final response = await _dio.get('/articles', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => ArticleItem.fromJson(r)).toList();
  }

  Future<ArticleItem> fetchSingleArticle(String id) async {
    final response = await _dio.get('/articles/$id');
    return ArticleItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ArticleItem>> fetchArticlesByPosition({
    int quantity = 1,
    required int position,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
    };
    final response = await _dio.get('/articles', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => ArticleItem.fromJson(r)).toList();
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<ArticleAuthor>> fetchAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'published': true,
      'page': page,
      'pageSize': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response =
        await _dio.get('/articles/authors', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => ArticleAuthor.fromJson(r)).toList();
  }

  Future<ArticleAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/authors/$id');
    return ArticleAuthor.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<ArticleCategory>> fetchCategories({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'published': true,
      'page': page,
      'pageSize': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response =
        await _dio.get('/articles/categories', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => ArticleCategory.fromJson(r)).toList();
  }

  Future<ArticleCategory> fetchCategory(String id) async {
    final response = await _dio.get('/categories/$id');
    return ArticleCategory.fromJson(response.data as Map<String, dynamic>);
  }
}
