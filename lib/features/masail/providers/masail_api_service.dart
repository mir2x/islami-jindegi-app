import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/content_scope.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/page_content.dart';

/// Dio-based service for fetching masail from the .NET API (plain JSON).
///
/// `fetchSettings` backs the "ask a question" FAB. Both the settings and the
/// rules page now come from the .NET API.
class MasailApiService {
  late final Dio _dio;

  MasailApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
    ));
  }

  // ───────────────────── Masail ─────────────────────

  Future<List<MasailItem>> fetchMasail({
    int page = 1,
    int perPage = 9,
    String? search,
    String? authorId,
    String? categoryId,
    String? hasAudio,
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
      if (hasAudio != null && hasAudio.isNotEmpty) 'hasAudio': hasAudio,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };

    final response = await _dio.get('/masail', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => MasailItem.fromJson(r)).toList();
  }

  Future<MasailItem> fetchSingleMasail(String id,
      {ContentScope scope = ContentScope.all}) async {
    final response = await _dio.get(
      '/masail/$id',
      queryParameters: {
        if (scope.queryValue != null) 'scope': scope.queryValue,
      },
    );
    return MasailItem.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<MasailAuthor>> fetchAuthors({
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
    final response = await _dio.get('/masail/authors', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => MasailAuthor.fromJson(r)).toList();
  }

  Future<MasailAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/authors/$id');
    return MasailAuthor.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<MasailCategory>> fetchCategories({
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
        await _dio.get('/masail/categories', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => MasailCategory.fromJson(r)).toList();
  }

  Future<MasailCategory> fetchCategory(String id) async {
    final response = await _dio.get('/categories/$id');
    return MasailCategory.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Pages (for ask-question) ─────────────────────

  Future<PageContent> fetchPageBySlug(String slug) async {
    final response = await _dio.get('/pages/by-slug/$slug');
    return PageContent.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Settings (for ask-question FAB)

  Future<Map<String, dynamic>> fetchSettings() async {
    final response = await _dio.get('/settings');
    final data = Map<String, dynamic>.from(response.data as Map);
    return {'ask-question': data['askQuestion'] == true};
  }
}
