import 'dart:math';

import 'package:dio/dio.dart';
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
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (authorId != null) 'authorId': authorId,
      if (categoryId != null) 'categoryId': categoryId,
      if (hasAudio != null) 'hasAudio': hasAudio,
    };

    final response = await _dio.get('/malfuzat', queryParameters: params);
    debugPrint(
      '[MalfuzatApiService] fetchMalfuzat response status: ${response.statusCode}',
    );
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => MalfuzatItem.fromJson(r)).toList();
  }

  /// Picks a random published malfuzat matching the given filters. Uses the
  /// `total` count from a 1-item page to pick a random page, then fetches
  /// that single item — same "quantity of 1 pages" trick the old JSON:API
  /// `total_pages`-based random picker used.
  Future<MalfuzatItem?> fetchRandomMalfuzat({
    String? search,
    String? authorId,
    String? categoryId,
    bool? hasAudio,
  }) async {
    final baseParams = <String, dynamic>{
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (authorId != null) 'authorId': authorId,
      if (categoryId != null) 'categoryId': categoryId,
      if (hasAudio != null) 'hasAudio': hasAudio,
    };

    final initialResponse = await _dio.get(
      '/malfuzat',
      queryParameters: {...baseParams, 'page': 1, 'pageSize': 1},
    );
    final initialData = initialResponse.data['data'] as List? ?? [];
    if (initialData.isEmpty) return null;

    final total = (initialResponse.data['total'] as num?)?.toInt() ?? 1;
    if (total <= 1) return MalfuzatItem.fromJson(initialData.first);

    final randomPage = Random().nextInt(total) + 1;
    if (randomPage == 1) return MalfuzatItem.fromJson(initialData.first);

    final randomResponse = await _dio.get(
      '/malfuzat',
      queryParameters: {...baseParams, 'page': randomPage, 'pageSize': 1},
    );
    final randomData = randomResponse.data['data'] as List? ?? [];
    return randomData.isNotEmpty
        ? MalfuzatItem.fromJson(randomData.first)
        : MalfuzatItem.fromJson(initialData.first);
  }

  Future<MalfuzatItem> fetchSingleMalfuzat(String id) async {
    final response = await _dio.get('/malfuzat/$id');
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
