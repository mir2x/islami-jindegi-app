import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/services/hijri_api.dart';
import 'package:native_app/providers/geolocation.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.watch(preferencesAndGeolocationProvider.future);
  final prefs = data['preferences'];
  final String? _rawCountryCode = data['geolocation']['location']['countryCode'];
  final String? countryCode =
      (_rawCountryCode != null && _rawCountryCode.isNotEmpty)
          ? _rawCountryCode
          : (prefs.getString('countryCode')?.isNotEmpty == true
              ? prefs.getString('countryCode')
              : 'BD');
  debugPrint('[Hijri][provider] Re-evaluating. countryCode=$countryCode, '
      'isGeolocated=${data['geolocation']['isGeolocated']}');
  final coordinates = data['geolocation']['coordinates'];
  final String timezone = data['geolocation']['timezone'] ?? '';
  final int hijriAdjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;
  final String? backendUrl = dotenv.env['DOTNET_API_HOST_NAME'];

  final now = DateTime.now();
  final todayStr = _dateStr(
    DateTime(now.year, now.month, now.day + hijriAdjustment),
  );
  final tomorrowStr = _dateStr(
    DateTime(now.year, now.month, now.day + hijriAdjustment + 1),
  );

  Map<String, dynamic>? hijriToday;
  Map<String, dynamic>? hijriTomorrow;
  final cachedToday = _readCached(prefs.getString('hijriDataToday'), todayStr, countryCode);
  final cachedTomorrow =
      _readCached(prefs.getString('hijriDataTomorrow'), tomorrowStr, countryCode);
  debugPrint('[Hijri][provider] Cache check — todayRaw=${prefs.getString('hijriDataToday') != null ? 'present' : 'null'}, '
      'cachedToday=${cachedToday != null ? 'hit(day=${cachedToday['hijri_day']})' : 'miss'}');

  if (countryCode != null &&
      countryCode.isNotEmpty &&
      backendUrl != null &&
      backendUrl.isNotEmpty) {
    try {
      debugPrint('[Hijri][provider] Calling .NET Hijri API for $countryCode');
      final api = HijriApi(backendUrl);

      final results = await Future.wait([
        api.getDate(date: todayStr, countryCode: countryCode),
        api.getDate(date: tomorrowStr, countryCode: countryCode),
      ]);

      final todayData = results[0];
      final tomorrowData = results[1];
      debugPrint('[Hijri][provider] Backend response — todayData=$todayData');

      if (todayData != null) {
        hijriToday = {...Map<String, dynamic>.from(todayData), 'date': todayStr, 'countryCode': countryCode};
        await prefs.setString('hijriDataToday', jsonEncode(hijriToday));
        debugPrint('[Hijri][provider] Backend success: hijri_day=${hijriToday['hijri_day']}');
      } else {
        hijriToday = cachedToday;
        debugPrint('[Hijri][provider] Backend returned null data, using cache: ${cachedToday?['hijri_day']}');
      }
      if (tomorrowData != null) {
        hijriTomorrow = {...Map<String, dynamic>.from(tomorrowData), 'date': tomorrowStr, 'countryCode': countryCode};
        await prefs.setString('hijriDataTomorrow', jsonEncode(hijriTomorrow));
      } else {
        hijriTomorrow = cachedTomorrow;
      }
    } catch (e) {
      debugPrint('[Hijri][provider] Backend call FAILED: $e. Falling back to cache: ${cachedToday?['hijri_day']}');
      hijriToday = cachedToday;
      hijriTomorrow = cachedTomorrow;
    }
  } else {
    debugPrint('[Hijri][provider] Skipping backend (countryCode=$countryCode, backendUrl=$backendUrl). Using cache.');
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

Map<String, dynamic>? _readCached(String? raw, String expectedDate, String? expectedCountryCode) {
  if (raw == null) return null;
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  if (decoded['date'] != expectedDate) return null;
  final cachedCountry = decoded['countryCode'] as String?;
  if (cachedCountry != null && expectedCountryCode != null && cachedCountry != expectedCountryCode) return null;
  return decoded;
}
