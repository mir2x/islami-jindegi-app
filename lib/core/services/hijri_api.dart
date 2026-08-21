import 'package:dio/dio.dart';

/// Client for the .NET Hijri API. It normalizes its modern camelCase payload
/// to the existing app's snake_case date model in one place.
class HijriApi {
  HijriApi(String host)
      : _dio = Dio(
          BaseOptions(
            baseUrl: '$host/api',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        );

  final Dio _dio;

  Future<Map<String, dynamic>?> getDate({
    required String date,
    required String countryCode,
  }) async {
    final response = await _dio.get(
      '/hijri/date',
      queryParameters: {'date': date, 'country-code': countryCode},
    );
    final data = _data(response.data);
    return data == null ? null : _normalizeDate(data);
  }

  Future<Map<String, dynamic>?> getMonth({
    required int hijriYear,
    required int hijriMonth,
    required String countryCode,
  }) async {
    final response = await _dio.get(
      '/hijri/month',
      queryParameters: {
        'country-code': countryCode,
        'hijri-year': hijriYear,
        'hijri-month': hijriMonth,
      },
    );
    final data = _data(response.data);
    return data == null ? null : _normalizeMonth(data);
  }

  Map<String, dynamic>? _data(dynamic body) {
    if (body is! Map) return null;
    final data = body['data'];
    return data is Map ? Map<String, dynamic>.from(data) : null;
  }

  Map<String, dynamic> _normalizeDate(Map<String, dynamic> data) => {
        'hijri_year': data['hijriYear'],
        'hijri_month': data['hijriMonth'],
        'hijri_day': data['hijriDay'],
        'month_length': data['monthLength'],
        'month_name_en': data['monthNameEn'],
        'month_name_ar': data['monthNameAr'],
        'month_name_bn': data['monthNameBn'],
      };

  Map<String, dynamic> _normalizeMonth(Map<String, dynamic> data) => {
        'hijri_year': data['hijriYear'],
        'hijri_month': data['hijriMonth'],
        'month_length': data['monthLength'],
        'month_name_en': data['monthNameEn'],
        'month_name_ar': data['monthNameAr'],
        'month_name_bn': data['monthNameBn'],
        'gregorian_start_date': data['gregorianStartDate'],
        'next_gregorian_start_date': data['nextGregorianStartDate'],
      };
}
