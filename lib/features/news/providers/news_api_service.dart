import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news.dart';

/// Dio-based service for fetching news from the .NET API (plain JSON).
///
/// The .NET `GetList` endpoint has no `gtPublishedAt`/`ltPublishedAt`
/// adjacency filter the legacy Ruby API had, so date-based prev/next lookup
/// is gone. Previous/next navigation is instead resolved via
/// `newsNavigationIdsProvider`, which pages through the (published) list
/// once and looks up the current item's index — mirroring the pattern used
/// by book/masail/dua.
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
