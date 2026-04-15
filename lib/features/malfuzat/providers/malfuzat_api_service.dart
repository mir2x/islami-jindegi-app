import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';
import '../models/malfuzat_subcategory.dart';

/// Dio-based service for fetching malfuzat from the JSON:API backend.
class MalfuzatApiService {
  late final Dio _dio;

  MalfuzatApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── Malfuzat ─────────────────────

  Future<List<MalfuzatItem>> fetchMalfuzat({
    int page = 1,
    int perPage = 9,
    String? search,
    String? malfuzatAuthorId,
    String? malfuzatCategoryId,
    String? malfuzatSubcategoryId,
    String? hasAudio,
    bool includeAuthor = true,
    bool random = false,
    int? quantity,
    bool? offline,
  }) async {
    final params = <String, dynamic>{
      if (random) ...{
        'random': true,
        if (quantity != null) 'quantity': quantity,
        if (offline != null) 'offline': offline,
      } else ...{
        'page': page,
        'per_page': perPage,
        'published': true,
      },
      if (includeAuthor) 'include': 'malfuzat-author',
      if (search != null && search.isNotEmpty) 'search': search,
      if (malfuzatAuthorId != null) 'malfuzatAuthorId': malfuzatAuthorId,
      if (malfuzatCategoryId != null) 'malfuzatCategoryId': malfuzatCategoryId,
      if (malfuzatSubcategoryId != null)
        'malfuzatSubcategoryId': malfuzatSubcategoryId,
      if (hasAudio != null && hasAudio.isNotEmpty) 'hasAudio': hasAudio,
    };

    final response = await _dio.get('/malfuzats', queryParameters: params);
    return _parseMalfuzatResponse(response.data);
  }

  Future<MalfuzatItem> fetchSingleMalfuzat(String id,
      {bool includeAuthor = true}) async {
    final params = <String, dynamic>{
      if (includeAuthor) 'include': 'malfuzat-author',
    };
    final response = await _dio.get('/malfuzats/$id', queryParameters: params);
    return _parseSingleMalfuzatResponse(response.data);
  }

  Future<List<MalfuzatItem>> fetchMalfuzatByPosition({
    int quantity = 1,
    required int position,
    bool includeAuthor = true,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
      if (includeAuthor) 'include': 'malfuzat-author',
    };
    final response = await _dio.get('/malfuzats', queryParameters: params);
    return _parseMalfuzatResponse(response.data);
  }

  // ───────────────────── Authors ─────────────────────

  Future<List<MalfuzatAuthor>> fetchAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response =
        await _dio.get('/malfuzat_authors', queryParameters: params);
    return _parseAuthorsResponse(response.data);
  }

  Future<MalfuzatAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/malfuzat_authors/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MalfuzatAuthor.fromJsonApi(data);
  }

  // ───────────────────── Categories ─────────────────────

  Future<List<MalfuzatCategory>> fetchCategories({
    int page = 1,
    int perPage = 16,
    String? search,
    bool includeSubcategories = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (includeSubcategories) 'include': 'malfuzat-subcategories',
    };
    final response =
        await _dio.get('/malfuzat_categories', queryParameters: params);
    return _parseCategoriesResponse(response.data);
  }

  Future<MalfuzatCategory> fetchCategory(String id) async {
    final response = await _dio.get('/malfuzat_categories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MalfuzatCategory.fromJsonApi(data);
  }

  // ───────────────────── Subcategories ─────────────────────

  Future<MalfuzatSubcategory> fetchSubcategory(String id) async {
    final response = await _dio.get('/malfuzat_subcategories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MalfuzatSubcategory.fromJsonApi(data);
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

  List<MalfuzatItem> _parseMalfuzatResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final authorId = _resolveSingleRelId(resource, 'malfuzat-author');
      String? authorName;
      if (authorId != null) {
        final authorRes = included['malfuzat_authors:$authorId'];
        if (authorRes != null) {
          final attrs = authorRes['attributes'] as Map<String, dynamic>? ?? {};
          authorName = attrs['name'];
        }
      }
      return MalfuzatItem.fromJsonApi(resource, resolvedAuthorName: authorName);
    }).toList();
  }

  MalfuzatItem _parseSingleMalfuzatResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final authorId = _resolveSingleRelId(resource, 'malfuzat-author');
    String? authorName;
    if (authorId != null) {
      final authorRes = included['malfuzat_authors:$authorId'];
      if (authorRes != null) {
        final attrs = authorRes['attributes'] as Map<String, dynamic>? ?? {};
        authorName = attrs['name'];
      }
    }
    return MalfuzatItem.fromJsonApi(resource, resolvedAuthorName: authorName);
  }

  List<MalfuzatAuthor> _parseAuthorsResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => MalfuzatAuthor.fromJsonApi(r)).toList();
  }

  List<MalfuzatCategory> _parseCategoriesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final subcatIds = _resolveRelIds(resource, 'malfuzat-subcategories');
      final subcategories = subcatIds
          .map((id) => included['malfuzat_subcategories:$id'])
          .where((s) => s != null)
          .map((s) => MalfuzatSubcategory.fromJsonApi(s!))
          .toList();

      return MalfuzatCategory.fromJsonApi(resource,
          resolvedSubcategories: subcategories);
    }).toList();
  }
}
