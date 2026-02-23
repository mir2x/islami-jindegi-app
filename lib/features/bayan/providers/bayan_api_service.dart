import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/bayan.dart';
import '../models/speaker.dart';
import '../models/bayan_category.dart';

/// Dio-based service for fetching bayans from the JSON:API backend.
class BayanApiService {
  late final Dio _dio;

  BayanApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── Bayans ─────────────────────

  Future<List<Bayan>> fetchBayans({
    int page = 1,
    int perPage = 9,
    String? search,
    String? speakerId,
    String? bayanCategoryId,
    String? dateRange,
    String? dateFrom,
    String? dateTo,
    bool includeSpeaker = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'published': true,
      if (includeSpeaker) 'include': 'speaker',
      if (search != null && search.isNotEmpty) 'search': search,
      if (speakerId != null) 'speakerId': speakerId,
      if (bayanCategoryId != null) 'bayanCategoryId': bayanCategoryId,
      if (dateRange != null && dateRange.isNotEmpty) 'dateRange': dateRange,
      if (dateFrom != null && dateFrom.isNotEmpty) 'dateFrom': dateFrom,
      if (dateTo != null && dateTo.isNotEmpty) 'dateTo': dateTo,
    };

    final response = await _dio.get('/bayans', queryParameters: params);
    return _parseBayansResponse(response.data);
  }

  Future<Bayan> fetchBayan(String id, {bool includeSpeaker = true}) async {
    final params = <String, dynamic>{
      if (includeSpeaker) 'include': 'speaker',
    };

    final response = await _dio.get('/bayans/$id', queryParameters: params);
    return _parseSingleBayanResponse(response.data);
  }

  /// Fetch adjacent bayan by position (for previous/next navigation)
  Future<List<Bayan>> fetchBayansByPosition({
    int quantity = 1,
    required int position,
    bool includeSpeaker = true,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
      if (includeSpeaker) 'include': 'speaker',
    };

    final response = await _dio.get('/bayans', queryParameters: params);
    return _parseBayansResponse(response.data);
  }

  // ───────────────────── Speakers (for filters) ─────────────────────

  Future<List<Speaker>> fetchSpeakers({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/speakers', queryParameters: params);
    return _parseSpeakersResponse(response.data);
  }

  Future<Speaker> fetchSpeaker(String id) async {
    final response = await _dio.get('/speakers/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return Speaker.fromJsonApi(data);
  }

  // ───────────────────── Bayan Categories (for filters) ─────────────────────

  Future<List<BayanCategory>> fetchBayanCategories({
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
        await _dio.get('/bayan_categories', queryParameters: params);
    return _parseCategoriesResponse(response.data);
  }

  Future<BayanCategory> fetchBayanCategory(String id) async {
    final response = await _dio.get('/bayan_categories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return BayanCategory.fromJsonApi(data);
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

  List<String> _resolveRelIds(
    Map<String, dynamic> resource,
    String relName,
  ) {
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

  String? _resolveSingleRelId(
    Map<String, dynamic> resource,
    String relName,
  ) {
    final ids = _resolveRelIds(resource, relName);
    return ids.isNotEmpty ? ids.first : null;
  }

  // ─── Bayans parsing ───

  List<Bayan> _parseBayansResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final speakerId = _resolveSingleRelId(resource, 'speaker');
      String? speakerName;
      if (speakerId != null) {
        final speakerResource = included['speakers:$speakerId'];
        if (speakerResource != null) {
          final attrs =
              speakerResource['attributes'] as Map<String, dynamic>? ?? {};
          speakerName = attrs['name'];
        }
      }

      return Bayan.fromJsonApi(resource, resolvedSpeakerName: speakerName);
    }).toList();
  }

  Bayan _parseSingleBayanResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final speakerId = _resolveSingleRelId(resource, 'speaker');
    String? speakerName;
    if (speakerId != null) {
      final speakerResource = included['speakers:$speakerId'];
      if (speakerResource != null) {
        final attrs =
            speakerResource['attributes'] as Map<String, dynamic>? ?? {};
        speakerName = attrs['name'];
      }
    }

    return Bayan.fromJsonApi(resource, resolvedSpeakerName: speakerName);
  }

  // ─── Speakers parsing ───

  List<Speaker> _parseSpeakersResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => Speaker.fromJsonApi(r)).toList();
  }

  // ─── Categories parsing ───

  List<BayanCategory> _parseCategoriesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => BayanCategory.fromJsonApi(r)).toList();
  }
}
