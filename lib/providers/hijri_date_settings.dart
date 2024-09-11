import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.watch(preferencesAndGeolocationProvider.future);

  String? countryCode = data['geolocation']['location']['countryCode'];

  int? localAdjustment = data['preferences'].getInt('hijriLocalAdjustment');
  int adjustment = localAdjustment ?? 0;

  if (localAdjustment == null && countryCode != null) {
    var query = AllModelsQuery(
      repository: ref.hijriAdjustments,
      params: {'country-code': countryCode, 'quantity': 1},
    );

    final adminAdjustment = await ref.read(allModelsProvider(query).future);

    if (adminAdjustment.isNotEmpty) {
      adjustment = adminAdjustment.first.adjustment;
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
