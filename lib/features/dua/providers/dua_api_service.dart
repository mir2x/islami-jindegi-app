import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

/// Dio-based service for fetching duas from the JSON:API backend.
class DuaApiService {
  late final Dio _dio;

  DuaApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
        headers: {'Accept': 'application/vnd.api+json'},
      ),
    );
  }

  // ───────────────────── Duas ─────────────────────

  /// Fetches all duas (offline mode – no pagination).
  Future<List<DuaItem>> fetchDuas({
    String? search,
    String? duaCategoryId,
    bool offline = true,
  }) async {
    final params = <String, dynamic>{
      'published': true,
      'offline': offline,
      if (search != null && search.isNotEmpty) 'search': search,
      if (duaCategoryId != null) 'duaCategoryId': duaCategoryId,
    };

    final response = await _dio.get('/duas', queryParameters: params);
    return _parseDuasResponse(response.data);
  }

  Future<DuaItem> fetchSingleDua(String id) async {
    final response = await _dio.get('/duas/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return DuaItem.fromJsonApi(data);
  }

  Future<List<DuaItem>> fetchDuasByPosition({
    int quantity = 1,
    required int position,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
    };
    final response = await _dio.get('/duas', queryParameters: params);
    return _parseDuasResponse(response.data);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<DuaCategory>> fetchCategories({
    int page = 1,
    int perPage = 16,
    String? search,
    bool offline = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      'offline': offline,
    };
    final response = await _dio.get('/dua_categories', queryParameters: params);
    return _parseCategoriesResponse(response.data);
  }

  Future<DuaCategory> fetchCategory(String id) async {
    final response = await _dio.get('/dua_categories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return DuaCategory.fromJsonApi(data);
  }

  // ═══════════════════════════════════════════════
  //  JSON:API Response Parsing
  // ═══════════════════════════════════════════════

  List<DuaItem> _parseDuasResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => DuaItem.fromJsonApi(r)).toList();
  }

  List<DuaCategory> _parseCategoriesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => DuaCategory.fromJsonApi(r)).toList();
  }
}
