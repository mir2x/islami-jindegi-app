import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/helpers/update_app_widget.dart';

final hijriDateSettingsProvider = FutureProvider((ref) async {
  final data = await ref.read(preferencesAndGeolocationProvider.future);

  String? countryCode = data['geolocation']['location']['countryCode'];

  int hijriAdjustment = data['preferences'].getInt('hijriAdjustment') ?? 0;
  int localAdjustment = data['preferences'].getInt('hijriLocalAdjustment') ?? 0;
  int adjustment = localAdjustment;

  if (adjustment == 0 && countryCode != null) {
    var query = AllModelsQuery(
      repository: ref.hijriAdjustments,
      params: {'country-code': countryCode, 'quantity': 1},
    );

    final adminAdjustment = await ref.read(allModelsProvider(query).future);

    if (adminAdjustment.isNotEmpty) {
      adjustment = adminAdjustment.first.adjustment;
    }
  }

  if (adjustment != hijriAdjustment) {
    await data['preferences'].setInt('hijriAdjustment', adjustment);
    updateAppWidget({'hijriAdjustment': adjustment});
  }

  return {
    'preferences': data['preferences'],
    'coordinates': data['geolocation']['coordinates'],
    'hijriAdjustment': adjustment,
  };
});
