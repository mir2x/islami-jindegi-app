import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/objects/prayer_time.dart';

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
    var textTheme = Theme.of(context).textTheme;
    var dataP = ref.watch(preferencesAndGeolocationProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return dataP.when(
      loading: () => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 15),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
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

        String location = geolocation['location']
            .values
            .where((v) => v is String && v.isNotEmpty)
            .join(', ');

        return Column(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: isMobile ? 0 : 5),
              child: Row(
                children: [
                  Text(location, style: textTheme.labelSmall),
                  if (!geolocation['isGeolocated']) ...[
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 3),
                      child: GestureDetector(
                        onTap: () => ref
                            .read(geolocationProvider.notifier)
                            .updateCoordinates(),
                        child: SvgPicture.asset(
                          'assets/images/icons/location.svg',
                          fit: BoxFit.scaleDown,
                          width: 30,
                          height: 23,
                        ),
                      ),
                    ),
                    Text(locales.setLocation, style: textTheme.labelSmall),
                  ],
                ],
              ),
            ),
            if (prayerTimes.containsKey('current')) ...[
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
                    )
                  ],
                ),
              ),
            ],
            Text(
              '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}',
              style: textTheme.labelSmall,
            ),
          ],
        );
      },
    );
  }
}
