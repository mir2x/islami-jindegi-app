import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.read(preferencesAndGeolocationProvider.future);

  int adminHijriAdjustment = 0;

  String? countryCode = data['geolocation']['location']['countryCode'];

  if (countryCode != null) {
    var query = AllModelsQuery(
      repository: ref.hijriAdjustments,
      params: {'country-code': countryCode, 'quantity': 1},
    );

    final hijriAdjustment = await ref.read(allModelsProvider(query).future);

    if (hijriAdjustment.isNotEmpty) {
      adminHijriAdjustment = hijriAdjustment.first.adjustment;
    }
  }

  return {
    'preferences': data['preferences'],
    'coordinates': data['geolocation']['coordinates'],
    'adminHijriAdjustment': adminHijriAdjustment,
  };
});
