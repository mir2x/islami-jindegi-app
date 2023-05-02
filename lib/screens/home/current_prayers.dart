import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/theme/colors.dart';

class CurrentPrayers extends ConsumerWidget {
  const CurrentPrayers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var dataP = ref.watch(preferencesAndGeolocationProvider);

    return dataP.when(
      loading: () => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 15),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Text(error.toString()),
      data: (Map data) {
        Map coordinates = data['geolocation']['coordinates'];

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

        String theme = data['preferences'].getString('theme') ?? 'dark';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme == 'dark' ? ThemeColors.color2 : ThemeColors.color3,
          ),
          child: Container(
            padding: data['geolocation']['isGeolocated']
                ? const EdgeInsets.symmetric(vertical: 17, horizontal: 15)
                : const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!data['geolocation']['isGeolocated']) ...[
                  Row(
                    children: [
                      Text(locales.dhaka, style: textTheme.labelSmall),
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
                  ),
                ],
                if (prayerTimes.containsKey('current')) ...[
                  Row(
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
                ],
                if (data['geolocation']['isGeolocated']) ...[
                  const SizedBox(height: 5),
                ],
                Text(
                  '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
