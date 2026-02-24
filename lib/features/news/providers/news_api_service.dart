import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news.dart';

/// Dio-based service for fetching news from the JSON:API backend.
class NewsApiService {
  late final Dio _dio;

  NewsApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── News ─────────────────────

  Future<List<NewsItem>> fetchNews({
    int page = 1,
    int perPage = 9,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/news', queryParameters: params);
    return _parseNewsResponse(response.data);
  }

  Future<NewsItem> fetchSingleNews(String id) async {
    final response = await _dio.get('/news/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return NewsItem.fromJsonApi(data);
  }

  /// Navigate by date — previous item (published after current).
  Future<List<NewsItem>> fetchNewsByGtPublishedAt({
    int quantity = 1,
    required String gtPublishedAt,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'published': true,
      'gtPublishedAt': gtPublishedAt,
    };
    final response = await _dio.get('/news', queryParameters: params);
    return _parseNewsResponse(response.data);
  }

  /// Navigate by date — next item (published before current).
  Future<List<NewsItem>> fetchNewsByLtPublishedAt({
    int quantity = 1,
    required String ltPublishedAt,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'published': true,
      'ltPublishedAt': ltPublishedAt,
    };
    final response = await _dio.get('/news', queryParameters: params);
    return _parseNewsResponse(response.data);
  }

  // ═══════════════════════════════════════════════
  //  JSON:API Response Parsing
  // ═══════════════════════════════════════════════

  List<NewsItem> _parseNewsResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => NewsItem.fromJsonApi(r)).toList();
  }
}
