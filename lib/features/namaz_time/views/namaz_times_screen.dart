import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/presentation/item_content.dart';

import 'namaz_time_items.dart';

class NamazTimes extends ConsumerWidget {
  const NamazTimes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return AppScaffold(
      title: Text(locales.namazTime),
      body: settingsProvider.when(
        loading: () {
          var dataProvider = ref.watch(preferencesAndGeolocationProvider);

          return dataProvider.when(
            loading: () => Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(error.toString()),
            data: (Map data) {
              int? localAdjustment =
                  data['preferences'].getInt('hijriLocalAdjustment');
              int adjustment = localAdjustment ?? 0;

              return NamazTimesPage(
                settings: {
                  'preferences': data['preferences'],
                  'coordinates': data['geolocation']['coordinates'],
                  'timezone': data['geolocation']['timezone'],
                  'hijriAdjustment': adjustment,
                },
                isHijriLoading: true,
              );
            },
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (settings) {
          return NamazTimesPage(settings: settings);
        },
      ),
    );
  }
}

class NamazTimesPage extends ConsumerStatefulWidget {
  const NamazTimesPage({
    super.key,
    required this.settings,
    this.isHijriLoading = false,
  });

  final Map settings;
  final bool isHijriLoading;

  @override
  NamazTimesPageState createState() => NamazTimesPageState();
}

class NamazTimesPageState extends ConsumerState<NamazTimesPage> {
  @override
  Widget build(BuildContext context) {
    return const ItemContent(
      children: [
        NamazTimeItems(
          currentDate: null,
          isStartTime: true,
        ),
      ],
    );
  }
}
