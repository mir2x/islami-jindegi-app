import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/geolocation.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.watch(preferencesAndGeolocationProvider.future);

  String? countryCode = data['geolocation']['location']['countryCode'];

  int? localAdjustment = data['preferences'].getInt('hijriLocalAdjustment');
  int adjustment = localAdjustment ?? 0;

  if (localAdjustment == null && countryCode != null) {
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
        adjustment = attrs['adjustment'] is int ? attrs['adjustment'] : 0;
      }
    } catch (_) {
      // Silently fail — use default adjustment of 0
    }
  }

  if (adjustment != data['preferences'].getInt('hijriAdjustment')) {
    await data['preferences'].setInt('hijriAdjustment', adjustment);
  }

  return {
    'preferences': data['preferences'],
    'coordinates': data['geolocation']['coordinates'],
    'timezone': data['geolocation']['timezone'],
    'hijriAdjustment': adjustment,
  };
});
