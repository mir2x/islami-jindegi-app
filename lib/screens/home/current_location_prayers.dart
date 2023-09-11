import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/widgets/location/index.dart';
import 'package:native_app/objects/prayer_time.dart';

class CurrentLocationPrayers extends StatelessWidget {
  const CurrentLocationPrayers({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: isMobile ? 0 : 5),
              child: const CurrentLocation(),
            ),
          ],
        ),
        const CurrentPrayers(),
      ],
    );
  }
}

class CurrentPrayers extends ConsumerStatefulWidget {
  const CurrentPrayers({super.key});

  @override
  CurrentPrayersState createState() => CurrentPrayersState();
}

class CurrentPrayersState extends ConsumerState<CurrentPrayers> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var dataProvider = ref.watch(preferencesAndGeolocationProvider);

    return dataProvider.when(
      loading: () {
        var prefs = ref.watch(preferencesProvider);

        return prefs.when(
          loading: () => const SizedBox(
            width: 15,
            height: 15,
          ),
          error: (error, _) => Text(error.toString()),
          data: (preferences) {
            String? currentPrayerTitle =
                preferences.getString('currentPrayerTitle');
            String? currentPrayerTime =
                preferences.getString('currentPrayerTime');
            String? nextPrayer = preferences.getString('nextPrayer');

            if (currentPrayerTitle != null &&
                currentPrayerTime != null &&
                nextPrayer != null) {
              return Prayers(
                prayerTimes: {
                  'current': {
                    'title': currentPrayerTitle,
                    'time': currentPrayerTime,
                  },
                  'next': nextPrayer,
                },
              );
            } else {
              return const SizedBox(height: 45);
            }
          },
        );
      },
      error: (error, _) => Text(error.toString()),
      data: (Map data) {
        Map geolocation = data['geolocation'];
        Map coordinates = geolocation['coordinates'];

        PrayerTime prayerTime = PrayerTime(
          coordinates: Coordinates(
            coordinates['latitude'],
            coordinates['longitude'],
          ),
          preferences: data['preferences'],
        );

        Map prayerTimes = prayerTime.getCurrentAndNextPrayers(
          locales,
          currentLang,
        );

        return Prayers(
          prayerTimes: {
            'current': prayerTimes['current'],
            'next':
                '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}',
          },
        );
      },
    );
  }
}

class Prayers extends StatelessWidget {
  const Prayers({
    super.key,
    required this.prayerTimes,
  });

  final Map prayerTimes;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        if (prayerTimes.containsKey('current') &&
            prayerTimes['current'] != null) ...[
          Container(
            margin: EdgeInsets.only(bottom: isMobile ? 0 : 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${prayerTimes['current']['title']}',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: Text(
                    '${prayerTimes['current']['time']}',
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
        Text(prayerTimes['next'], style: textTheme.labelSmall),
      ],
    );
  }
}
