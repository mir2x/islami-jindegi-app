import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

/// Dio-based service for fetching duas from the .NET API (plain JSON).
///
/// Dua has no author concept — only a flat category filter.
class DuaApiService {
  late final Dio _dio;

  DuaApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
      ),
    );
  }

  // ───────────────────── Duas ─────────────────────

  Future<List<DuaItem>> fetchDuas({
    int page = 1,
    int perPage = 20,
    String? search,
    String? categoryId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (categoryId != null) 'categoryId': categoryId,
    };

    final response = await _dio.get('/dua', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => DuaItem.fromJson(r)).toList();
  }

  Future<DuaItem> fetchSingleDua(String id) async {
    final response = await _dio.get('/dua/$id');
    return DuaItem.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<DuaCategory>> fetchCategories({
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
    final response = await _dio.get('/dua/categories', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => DuaCategory.fromJson(r)).toList();
  }

  Future<DuaCategory> fetchCategory(String id) async {
    final response = await _dio.get('/categories/$id');
    return DuaCategory.fromJson(response.data as Map<String, dynamic>);
  }
}
