import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/geolocation.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.watch(preferencesAndGeolocationProvider.future);
  final prefs = data['preferences'];
  final String? countryCode = data['geolocation']['location']['countryCode'];

  // Step 1: Always fetch country-level adjustment from API.
  // Cache the last successful result in 'hijriCountryAdjustment'.
  // Fallback: cached value → -1 (most users are from Bangladesh).
  int countryAdjustment;
  if (countryCode != null) {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
        headers: {'Accept': 'application/vnd.api+json'},
      ));

      final response = await dio.get('/hijri_adjustments', queryParameters: {
        'country-code': countryCode,
        'quantity': 1,
      });

      final dataList = response.data['data'] as List? ?? [];
      if (dataList.isNotEmpty) {
        final attrs =
            dataList.first['attributes'] as Map<String, dynamic>? ?? {};
        countryAdjustment =
            attrs['adjustment'] is int ? attrs['adjustment'] : -1;
      } else {
        countryAdjustment = prefs.getInt('hijriCountryAdjustment') ?? -1;
      }

      // Cache the fresh API value
      await prefs.setInt('hijriCountryAdjustment', countryAdjustment);
    } catch (_) {
      // API failed — use last cached value, else fall back to -1
      countryAdjustment = prefs.getInt('hijriCountryAdjustment') ?? -1;
    }
  } else {
    countryAdjustment = prefs.getInt('hijriCountryAdjustment') ?? -1;
  }

  // Step 2: User's personal fine-tuning, additive on top of country value.
  // Defaults to 0 (no personal override).
  final int localAdjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;

  // Step 3: Effective = country + local (additive, not substitutive).
  final int effectiveAdjustment = countryAdjustment + localAdjustment;

  // Persist effective value so other parts of the app (e.g. namaz time page)
  // can read it directly from SharedPreferences without re-computing.
  if (effectiveAdjustment != prefs.getInt('hijriAdjustment')) {
    await prefs.setInt('hijriAdjustment', effectiveAdjustment);
  }

  return {
    'preferences': prefs,
    'coordinates': data['geolocation']['coordinates'],
    'timezone': data['geolocation']['timezone'],
    'hijriAdjustment': effectiveAdjustment,
  };
});
