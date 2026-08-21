import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AssetUrlResponse {
  final String url;
  final int sizeBytes;

  AssetUrlResponse({required this.url, required this.sizeBytes});

  factory AssetUrlResponse.fromJson(Map<String, dynamic> json) {
    return AssetUrlResponse(
      url: json['url'] as String,
      sizeBytes: json['sizeBytes'] as int,
    );
  }
}

class StaticAssetApi {
  static final StaticAssetApi _instance = StaticAssetApi._();
  factory StaticAssetApi() => _instance;
  StaticAssetApi._();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api/quran',
    ),
  );

  Future<AssetUrlResponse?> getMushafUrl(String mushafId) async {
    try {
      final response = await _dio.post(
        '/mushaf-url',
        data: {'mushafId': mushafId},
      );
      if (response.statusCode == 200) {
        return AssetUrlResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Failed to get mushaf URL: $e');
      return null;
    }
  }

  Future<AssetUrlResponse?> getTafsirUrl(String tafsirId) async {
    try {
      final response = await _dio.post(
        '/tafsir-url',
        data: {'tafsirId': tafsirId},
      );
      if (response.statusCode == 200) {
        return AssetUrlResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Failed to get tafsir URL: $e');
      return null;
    }
  }

  Future<AssetUrlResponse?> getDbUrl(String dbName) async {
    try {
      final response = await _dio.post(
        '/db-url',
        data: {'dbName': dbName},
      );
      if (response.statusCode == 200) {
        return AssetUrlResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Failed to get DB URL: $e');
      return null;
    }
  }
}
