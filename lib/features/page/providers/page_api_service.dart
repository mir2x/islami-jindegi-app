import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/page_item.dart';

/// Dio-based service for fetching pages by slug.
class PageApiService {
  late final Dio _dio;

  PageApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  Future<List<PageItem>> fetchBySlug(String slug) async {
    final params = <String, dynamic>{
      'slug': slug,
      'quantity': 1,
    };
    final response = await _dio.get('/pages', queryParameters: params);
    final dataList = response.data['data'] as List? ?? [];
    return dataList.map((r) => PageItem.fromJsonApi(r)).toList();
  }
}
