import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/page_content.dart';

/// Dio-based service for fetching masail from the .NET API (plain JSON).
///
/// `fetchSettings` is the exception: it backs the "ask a question" FAB's
/// contact info, which is generic Ruby `Settings` content. The .NET API has
/// no Settings controller yet, so that call stays on the legacy JSON:API host
/// via a second Dio client instead of being ported. `fetchPages` (the
/// question body/rules text, slug `ask-masail`) now uses the .NET Pages API
/// like the `page` module does, since that module has been migrated.
class MasailApiService {
  late final Dio _dio;
  late final Dio _legacyDio;

  MasailApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
    ));
    _legacyDio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
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
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (authorId != null) 'authorId': authorId,
      if (categoryId != null) 'categoryId': categoryId,
      if (hasAudio != null && hasAudio.isNotEmpty) 'hasAudio': hasAudio,
    };

    final response = await _dio.get('/masail', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => MasailItem.fromJson(r)).toList();
  }

  Future<MasailItem> fetchSingleMasail(String id) async {
    final response = await _dio.get('/masail/$id');
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

  // ───────────────────── Settings (for ask-question FAB) — legacy Ruby API

  Future<Map<String, dynamic>> fetchSettings() async {
    final response = await _legacyDio.get('/settings', queryParameters: {
      'quantity': 1,
    });
    final dataList = response.data['data'] as List? ?? [];
    if (dataList.isEmpty) return {};
    final attrs = dataList.first['attributes'] as Map<String, dynamic>? ?? {};
    return attrs;
  }
}
