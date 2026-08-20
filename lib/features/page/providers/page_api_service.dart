import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/page_item.dart';

/// Dio-based service for fetching pages by slug.
class PageApiService {
  late final Dio _dio;

  PageApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
        // Without these the request never settles on a network that accepts
        // the connection but delivers nothing (captive portal, "connected"
        // Wi-Fi with no internet), leaving the page screens on their loading
        // spinner forever instead of falling through to the offline copy.
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  Future<PageItem> fetchBySlug(String slug) async {
    final response = await _dio.get('/pages/by-slug/$slug');
    return PageItem.fromJson(response.data as Map<String, dynamic>);
  }
}
