import 'package:dio/dio.dart';

/// Client for the .NET `/api/timezone` endpoint, which resolves a coordinate to
/// its IANA zone from timezone-boundary-builder polygons.
///
/// Kept authoritative over the on-device lookup so a boundary change can be
/// corrected server-side without shipping an app release.
class TimezoneApi {
  TimezoneApi(String host)
      : _dio = Dio(
          BaseOptions(
            baseUrl: '$host/api',
            // Short: this sits in front of the prayer times on a location
            // change, and there is always a usable offline answer to fall back
            // to, so waiting is worse than falling back.
            connectTimeout: const Duration(seconds: 4),
            receiveTimeout: const Duration(seconds: 4),
          ),
        );

  final Dio _dio;

  /// Returns the IANA zone id, or null when the backend could not place the
  /// coordinate. Throws on transport failure — callers fall back offline.
  Future<String?> resolve({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get(
      '/timezone',
      queryParameters: {'lat': latitude, 'lng': longitude},
    );

    final body = response.data;
    if (body is! Map) return null;
    final data = body['data'];
    if (data is! Map) return null;
    final zoneId = data['timeZoneId'];
    return zoneId is String && zoneId.isNotEmpty ? zoneId : null;
  }
}
