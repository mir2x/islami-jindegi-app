import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/madrasah.dart';

/// Dio-based service for fetching madrasahs from the .NET API (plain JSON).
///
/// Madrasah has no author/category/audio concept, and its `infos`/`photos`
/// are nested directly inside `MadrasahDetail` — there's no standalone
/// `/madrasah_infos` or `/madrasah_photos` endpoint (unlike the old JSON:API
/// backend), so a single detail fetch is all any screen ever needs.
class MadrasahApiService {
  late final Dio _dio;

  MadrasahApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
      ),
    );
  }

  Future<List<MadrasahItem>> fetchMadrasahs({
    int page = 1,
    int perPage = 9,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/madrasahs', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => MadrasahItem.fromJson(r)).toList();
  }

  Future<MadrasahItem> fetchSingleMadrasah(String id) async {
    final response = await _dio.get('/madrasahs/$id');
    return MadrasahItem.fromJson(response.data as Map<String, dynamic>);
  }
}
