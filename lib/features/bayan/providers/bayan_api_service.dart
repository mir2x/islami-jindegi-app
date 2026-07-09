import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/bayan.dart';
import '../models/speaker.dart';
import '../models/bayan_category.dart';

/// Dio-based service for fetching bayans from the .NET API (plain JSON).
class BayanApiService {
  late final Dio _dio;

  BayanApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
    ));
  }

  // ───────────────────── Bayans ─────────────────────

  Future<List<Bayan>> fetchBayans({
    int page = 1,
    int perPage = 9,
    String? search,
    String? speakerId,
    String? categoryId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (speakerId != null) 'authorId': speakerId,
      if (categoryId != null) 'categoryId': categoryId,
    };

    final response = await _dio.get('/bayan', queryParameters: params);
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => Bayan.fromJson(r)).toList();
  }

  Future<Bayan> fetchBayan(String id) async {
    final response = await _dio.get('/bayan/$id');
    return Bayan.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Speakers (for filters) ─────────────────────
  // Bayan's "speaker" is the .NET API's generic Author resource — see
  // models/speaker.dart for why the Flutter-facing naming stays "Speaker".

  Future<List<Speaker>> fetchSpeakers({
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

    final response = await _dio.get('/bayan/authors', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => Speaker.fromJson(r)).toList();
  }

  Future<Speaker> fetchSpeaker(String id) async {
    final response = await _dio.get('/authors/$id');
    return Speaker.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Bayan Categories (for filters) ─────────────────────

  Future<List<BayanCategory>> fetchBayanCategories({
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
        await _dio.get('/bayan/categories', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => BayanCategory.fromJson(r)).toList();
  }

  Future<BayanCategory> fetchBayanCategory(String id) async {
    final response = await _dio.get('/categories/$id');
    return BayanCategory.fromJson(response.data as Map<String, dynamic>);
  }
}
