import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/page_item.dart';

/// Dio-based service for fetching pages by slug.
class PageApiService {
  late final Dio _dio;

  PageApiService() {
    _dio = Dio(BaseOptions(baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api'));
  }

  Future<PageItem> fetchBySlug(String slug) async {
    final response = await _dio.get('/pages/by-slug/$slug');
    return PageItem.fromJson(response.data as Map<String, dynamic>);
  }
}
