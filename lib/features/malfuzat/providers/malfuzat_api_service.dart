import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/content_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';

/// Dio-based service for fetching malfuzat from the .NET API (plain JSON).
class MalfuzatApiService {
  late final Dio _dio;

  MalfuzatApiService() {
    final baseUrl = '${dotenv.env['DOTNET_API_HOST_NAME']}/api';
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    debugPrint('[MalfuzatApiService] baseUrl=$baseUrl');
  }

  // ───────────────────── Malfuzat ─────────────────────

  Future<List<MalfuzatItem>> fetchMalfuzat({
    int page = 1,
    int perPage = 9,
    String? search,
    String? authorId,
    String? categoryId,
    bool? hasAudio,
    String? dateFrom,
    String? dateTo,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      'sort': 'position_desc',
      if (search != null && search.isNotEmpty) 'search': search,
      if (authorId != null) 'authorId': authorId,
      if (categoryId != null) 'categoryId': categoryId,
      if (hasAudio != null) 'hasAudio': hasAudio,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };

    final response = await _dio.get('/malfuzat', queryParameters: params);
    debugPrint(
      '[MalfuzatApiService] fetchMalfuzat response status: ${response.statusCode}',
    );
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => MalfuzatItem.fromJson(r)).toList();
  }

  /// One random published, text-only malfuzat by the popup author, for the
  /// home-screen dialog.
  ///
  /// The server owns which author this is. The previous implementation picked
  /// it here — read `total` from a 1-item page, pick a random page, fetch it —
  /// which meant the app carried the author's primary key. That key is not
  /// stable across backend migrations, and when it was reissued every install
  /// silently got zero results and the popup simply stopped appearing until a
  /// new store build shipped. Two round trips became one, and the app no
  /// longer knows or cares who the author is.
  ///
  /// Returns null when the server has no item to offer (204), which the caller
  /// must treat as "try offline", not as "show nothing".
  Future<MalfuzatItem?> fetchDailyMalfuzat() async {
    final response = await _dio.get('/malfuzat/daily');
    debugPrint(
      '[MalfuzatApiService] fetchDailyMalfuzat status: ${response.statusCode}',
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) return null;
    return MalfuzatItem.fromJson(data);
  }

  Future<MalfuzatItem> fetchSingleMalfuzat(String id,
      {ContentScope scope = ContentScope.all}) async {
    final response = await _dio.get(
      '/malfuzat/$id',
      queryParameters: {
        if (scope.queryValue != null) 'scope': scope.queryValue,
      },
    );
    debugPrint(
      '[MalfuzatApiService] fetchSingleMalfuzat($id) response status: ${response.statusCode}',
    );
    return MalfuzatItem.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Authors (for filters) ─────────────────────

  Future<List<MalfuzatAuthor>> fetchAuthors({
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
        await _dio.get('/malfuzat/authors', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => MalfuzatAuthor.fromJson(r)).toList();
  }

  Future<MalfuzatAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/authors/$id');
    return MalfuzatAuthor.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Categories (for filters) ─────────────────────

  Future<List<MalfuzatCategory>> fetchCategories({
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
        await _dio.get('/malfuzat/categories', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => MalfuzatCategory.fromJson(r)).toList();
  }

  Future<MalfuzatCategory> fetchCategory(String id) async {
    final response = await _dio.get('/categories/$id');
    return MalfuzatCategory.fromJson(response.data as Map<String, dynamic>);
  }
}
