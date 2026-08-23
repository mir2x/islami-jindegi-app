import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news.dart';

/// Dio-based service for fetching news from the .NET API (plain JSON).
///
/// Previous/next navigation comes from the `previous`/`next` refs the .NET
/// detail endpoint embeds in its response. News has no offline database, so
/// there is no local fallback for it.
class NewsApiService {
  late final Dio _dio;

  NewsApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
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
      'pageSize': perPage,
      'published': true,
      'sort': 'position_desc',
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/news', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => NewsItem.fromJson(r)).toList();
  }

  Future<NewsItem> fetchSingleNews(String id) async {
    final response = await _dio.get('/news/$id');
    return NewsItem.fromJson(response.data as Map<String, dynamic>);
  }
}
