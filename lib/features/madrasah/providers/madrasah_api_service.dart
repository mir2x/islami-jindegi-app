import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/madrasah.dart';
import '../models/madrasah_info.dart';
import '../models/madrasah_photo.dart';

/// Dio-based service for fetching madrasahs from the JSON:API backend.
class MadrasahApiService {
  late final Dio _dio;

  MadrasahApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── Madrasahs ─────────────────────

  Future<List<MadrasahItem>> fetchMadrasahs({
    int page = 1,
    int perPage = 9,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/madrasahs', queryParameters: params);
    return _parseMadrasahsResponse(response.data);
  }

  Future<MadrasahItem> fetchSingleMadrasah(
    String id, {
    bool includeInfos = false,
    bool includePhotos = false,
  }) async {
    final includes = <String>[];
    if (includeInfos) includes.add('madrasah-infos');
    if (includePhotos) includes.add('madrasah-photos');

    final params = <String, dynamic>{
      if (includes.isNotEmpty) 'include': includes.join(','),
    };

    final response = await _dio.get('/madrasahs/$id', queryParameters: params);
    return _parseSingleMadrasahResponse(response.data);
  }

  Future<List<MadrasahItem>> fetchMadrasahsByPosition({
    int quantity = 1,
    required int position,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
    };
    final response = await _dio.get('/madrasahs', queryParameters: params);
    return _parseMadrasahsResponse(response.data);
  }

  // ───────────────────── Madrasah Infos ─────────────────────

  Future<MadrasahInfoItem> fetchSingleInfo(
    String id, {
    bool includeMadrasah = false,
  }) async {
    final params = <String, dynamic>{
      if (includeMadrasah) 'include': 'madrasah',
    };
    final response =
        await _dio.get('/madrasah_infos/$id', queryParameters: params);
    return _parseSingleInfoResponse(response.data);
  }

  Future<List<MadrasahInfoItem>> fetchInfosByMadrasah({
    required String madrasahId,
    int quantity = 1,
    int? position,
    String? sort,
    bool localFirst = true,
  }) async {
    final params = <String, dynamic>{
      'madrasahId': madrasahId,
      'quantity': quantity,
      if (position != null) 'position': position,
      if (sort != null) 'sort': sort,
      'localFirst': localFirst,
    };
    final response = await _dio.get('/madrasah_infos', queryParameters: params);
    return _parseInfosResponse(response.data);
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

  String? _resolveSingleRelId(Map<String, dynamic> resource, String relName) {
    final rels = resource['relationships'] as Map<String, dynamic>?;
    if (rels == null || !rels.containsKey(relName)) return null;
    final relData = rels[relName]['data'];
    if (relData is Map) return relData['id']?.toString();
    return null;
  }

  MadrasahItem _parseMadrasahWithRelationships(
    Map<String, dynamic> resource,
    Map<String, Map<String, dynamic>> included,
  ) {
    // Resolve infos
    final infoIds = _resolveRelIds(resource, 'madrasah-infos');
    final infos = infoIds
        .map((id) => included['madrasah_infos:$id'])
        .where((s) => s != null)
        .map((s) => MadrasahInfoItem.fromJsonApi(s!))
        .toList();

    // Resolve photos
    final photoIds = _resolveRelIds(resource, 'madrasah-photos');
    final photos = photoIds
        .map((id) => included['madrasah_photos:$id'])
        .where((s) => s != null)
        .map((s) => MadrasahPhotoItem.fromJsonApi(s!))
        .toList();

    return MadrasahItem.fromJsonApi(
      resource,
      resolvedInfos: infos,
      resolvedPhotos: photos,
    );
  }

  List<MadrasahItem> _parseMadrasahsResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);
    return dataList
        .map((r) => _parseMadrasahWithRelationships(r, included))
        .toList();
  }

  MadrasahItem _parseSingleMadrasahResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);
    return _parseMadrasahWithRelationships(resource, included);
  }

  List<MadrasahInfoItem> _parseInfosResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => MadrasahInfoItem.fromJsonApi(r)).toList();
  }

  MadrasahInfoItem _parseSingleInfoResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final madrasahId = _resolveSingleRelId(resource, 'madrasah');
    String? madrasahTitle;
    if (madrasahId != null) {
      final madrasahRes = included['madrasahs:$madrasahId'];
      if (madrasahRes != null) {
        final attrs = madrasahRes['attributes'] as Map<String, dynamic>? ?? {};
        madrasahTitle = attrs['title'];
      }
    }

    return MadrasahInfoItem.fromJsonApi(
      resource,
      resolvedMadrasahId: madrasahId,
      resolvedMadrasahTitle: madrasahTitle,
    );
  }
}
