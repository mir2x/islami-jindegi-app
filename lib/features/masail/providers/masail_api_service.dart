import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/masail_subcategory.dart';
import '../models/page_content.dart';

/// Dio-based service for fetching masail from the JSON:API backend.
class MasailApiService {
  late final Dio _dio;

  MasailApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── Masail ─────────────────────

  Future<List<MasailItem>> fetchMasail({
    int page = 1,
    int perPage = 9,
    String? search,
    String? masailAuthorId,
    String? masailCategoryId,
    String? masailSubcategoryId,
    String? hasAudio,
    bool includeAuthor = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'published': true,
      if (includeAuthor) 'include': 'masail-author',
      if (search != null && search.isNotEmpty) 'search': search,
      if (masailAuthorId != null) 'masailAuthorId': masailAuthorId,
      if (masailCategoryId != null) 'masailCategoryId': masailCategoryId,
      if (masailSubcategoryId != null)
        'masailSubcategoryId': masailSubcategoryId,
      if (hasAudio != null && hasAudio.isNotEmpty) 'hasAudio': hasAudio,
    };

    final response = await _dio.get('/masails', queryParameters: params);
    return _parseMasailResponse(response.data);
  }

  Future<MasailItem> fetchSingleMasail(String id,
      {bool includeAuthor = true}) async {
    final params = <String, dynamic>{
      if (includeAuthor) 'include': 'masail-author',
    };
    final response = await _dio.get('/masails/$id', queryParameters: params);
    return _parseSingleMasailResponse(response.data);
  }

  Future<List<MasailItem>> fetchMasailByPosition({
    int quantity = 1,
    required int position,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
    };
    final response = await _dio.get('/masails', queryParameters: params);
    return _parseMasailResponse(response.data);
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<MasailAuthor>> fetchAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response = await _dio.get('/masail_authors', queryParameters: params);
    return _parseAuthorsResponse(response.data);
  }

  Future<MasailAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/masail_authors/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MasailAuthor.fromJsonApi(data);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<MasailCategory>> fetchCategories({
    int page = 1,
    int perPage = 16,
    String? search,
    bool includeSubcategories = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (includeSubcategories) 'include': 'masail-subcategories',
    };
    final response =
        await _dio.get('/masail_categories', queryParameters: params);
    return _parseCategoriesResponse(response.data);
  }

  Future<MasailCategory> fetchCategory(String id) async {
    final response = await _dio.get('/masail_categories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MasailCategory.fromJsonApi(data);
  }

  // ───────────────────── Subcategories ─────────────────────

  Future<MasailSubcategory> fetchSubcategory(String id) async {
    final response = await _dio.get('/masail_subcategories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MasailSubcategory.fromJsonApi(data);
  }

  // ───────────────────── Pages (for ask-question) ─────────────────────

  Future<List<PageContent>> fetchPages({
    String? slug,
    int? quantity,
  }) async {
    final params = <String, dynamic>{
      if (slug != null) 'slug': slug,
      if (quantity != null) 'quantity': quantity,
    };
    final response = await _dio.get('/pages', queryParameters: params);
    return _parsePagesResponse(response.data);
  }

  // ───────────────────── Settings (for ask-question FAB) ─────────────────────

  Future<Map<String, dynamic>> fetchSettings() async {
    final response = await _dio.get('/settings', queryParameters: {
      'quantity': 1,
    });
    final dataList = response.data['data'] as List? ?? [];
    if (dataList.isEmpty) return {};
    final attrs = dataList.first['attributes'] as Map<String, dynamic>? ?? {};
    return attrs;
  }

  // ═══════════════════════════════════════════════
  //  JSON:API Response Parsing
  // ═══════════════════════════════════════════════

  Map<String, Map<String, dynamic>> _buildIncludedMap(dynamic included) {
    final map = <String, Map<String, dynamic>>{};
    if (included is List) {
      for (final item in included) {
        final type = item['type']?.toString() ?? '';
        final id = item['id']?.toString() ?? '';
        map['$type:$id'] = item as Map<String, dynamic>;
      }
    }
    return map;
  }

  String? _resolveSingleRelId(Map<String, dynamic> resource, String relName) {
    final rels = resource['relationships'] as Map<String, dynamic>?;
    if (rels == null || !rels.containsKey(relName)) return null;
    final relData = rels[relName]['data'];
    if (relData is Map) return relData['id']?.toString();
    return null;
  }

  List<String> _resolveRelIds(Map<String, dynamic> resource, String relName) {
    final rels = resource['relationships'] as Map<String, dynamic>?;
    if (rels == null || !rels.containsKey(relName)) return [];
    final relData = rels[relName]['data'];
    if (relData is List) {
      return relData.map((r) => r['id'].toString()).toList();
    } else if (relData is Map) {
      return [relData['id'].toString()];
    }
    return [];
  }

  List<MasailItem> _parseMasailResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final authorId = _resolveSingleRelId(resource, 'masail-author');
      String? authorName;
      if (authorId != null) {
        final authorRes = included['masail_authors:$authorId'];
        if (authorRes != null) {
          final attrs = authorRes['attributes'] as Map<String, dynamic>? ?? {};
          authorName = attrs['name'];
        }
      }
      return MasailItem.fromJsonApi(resource, resolvedAuthorName: authorName);
    }).toList();
  }

  MasailItem _parseSingleMasailResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final authorId = _resolveSingleRelId(resource, 'masail-author');
    String? authorName;
    if (authorId != null) {
      final authorRes = included['masail_authors:$authorId'];
      if (authorRes != null) {
        final attrs = authorRes['attributes'] as Map<String, dynamic>? ?? {};
        authorName = attrs['name'];
      }
    }
    return MasailItem.fromJsonApi(resource, resolvedAuthorName: authorName);
  }

  List<MasailAuthor> _parseAuthorsResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => MasailAuthor.fromJsonApi(r)).toList();
  }

  List<MasailCategory> _parseCategoriesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final subcatIds = _resolveRelIds(resource, 'masail-subcategories');
      final subcategories = subcatIds
          .map((id) => included['masail_subcategories:$id'])
          .where((s) => s != null)
          .map((s) => MasailSubcategory.fromJsonApi(s!))
          .toList();

      return MasailCategory.fromJsonApi(resource,
          resolvedSubcategories: subcategories);
    }).toList();
  }

  List<PageContent> _parsePagesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => PageContent.fromJsonApi(r)).toList();
  }
}
