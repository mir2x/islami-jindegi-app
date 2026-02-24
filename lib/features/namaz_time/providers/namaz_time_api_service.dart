import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/namaz_time.dart';

/// Dio-based service for fetching namaz times from the JSON:API backend.
class NamazTimeApiService {
  late final Dio _dio;

  NamazTimeApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  /// Fetch namaz time by slug (used in detail screen).
  Future<List<NamazTimeItem>> fetchBySlug(String slug) async {
    final params = <String, dynamic>{
      'slug': slug,
      'quantity': 1,
    };
    final response = await _dio.get('/namaz_times', queryParameters: params);
    return _parseResponse(response.data);
  }

  /// Navigate by position (prev/next).
  Future<List<NamazTimeItem>> fetchByPosition({
    int quantity = 1,
    required int position,
  }) async {
    final params = <String, dynamic>{
      'quantity': quantity,
      'position': position,
    };
    final response = await _dio.get('/namaz_times', queryParameters: params);
    return _parseResponse(response.data);
  }

  List<NamazTimeItem> _parseResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => NamazTimeItem.fromJsonApi(r)).toList();
  }
}
