import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/geolocation.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.watch(preferencesAndGeolocationProvider.future);
  final prefs = data['preferences'];
  final String? countryCode =
      data['geolocation']['location']['countryCode'] ??
      prefs.getString('countryCode') ??
      'BD';
  final coordinates = data['geolocation']['coordinates'];
  final String timezone = data['geolocation']['timezone'] ?? '';
  final int hijriAdjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;
  final String? backendUrl =
      prefs.getString('hijriBackendUrl') ?? dotenv.env['HIJRI_BACKEND_URL'];

  final now = DateTime.now();
  final todayStr = _dateStr(
    DateTime(now.year, now.month, now.day + hijriAdjustment),
  );
  final tomorrowStr = _dateStr(
    DateTime(now.year, now.month, now.day + hijriAdjustment + 1),
  );

  Map<String, dynamic>? hijriToday;
  Map<String, dynamic>? hijriTomorrow;
  final cachedToday = _readCached(prefs.getString('hijriDataToday'), todayStr);
  final cachedTomorrow =
      _readCached(prefs.getString('hijriDataTomorrow'), tomorrowStr);

  if (countryCode != null &&
      countryCode.isNotEmpty &&
      backendUrl != null &&
      backendUrl.isNotEmpty) {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: '$backendUrl/api',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),);

      final results = await Future.wait([
        dio.get('/hijri_date', queryParameters: {'date': todayStr, 'country-code': countryCode}),
        dio.get('/hijri_date', queryParameters: {'date': tomorrowStr, 'country-code': countryCode}),
      ]);

      final todayData = results[0].data['data'];
      final tomorrowData = results[1].data['data'];

      if (todayData != null) {
        hijriToday = {...Map<String, dynamic>.from(todayData), 'date': todayStr};
        await prefs.setString('hijriDataToday', jsonEncode(hijriToday));
      } else {
        hijriToday = cachedToday;
      }
      if (tomorrowData != null) {
        hijriTomorrow = {...Map<String, dynamic>.from(tomorrowData), 'date': tomorrowStr};
        await prefs.setString('hijriDataTomorrow', jsonEncode(hijriTomorrow));
      } else {
        hijriTomorrow = cachedTomorrow;
      }
    } catch (_) {
      hijriToday = cachedToday;
      hijriTomorrow = cachedTomorrow;
    }
  } else {
    hijriToday = cachedToday;
    hijriTomorrow = cachedTomorrow;
  }

  return {
    'preferences': prefs,
    'coordinates': coordinates,
    'timezone': timezone,
    'countryCode': countryCode,
    'backendUrl': backendUrl,
    'hijriDataToday': hijriToday,
    'hijriDataTomorrow': hijriTomorrow,
    'hijriAdjustment': hijriAdjustment,
  };
});

String _dateStr(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Map<String, dynamic>? _readCached(String? raw, String expectedDate) {
  if (raw == null) return null;
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  return decoded['date'] == expectedDate ? decoded : null;
}
