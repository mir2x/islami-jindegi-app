import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/screens/namaz_times/settings.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'item.dart';

class NamazTimes extends ConsumerWidget {
  const NamazTimes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var dataP = ref.watch(preferencesAndGeolocationProvider);

    return MyScaffold(
      title: Text(locales.namazTime),
      body: ItemContent(
        children: [
          const Center(
            child: HijriDate(),
          ),
          dataP.when(
            loading: () => Container(
              margin: const EdgeInsets.only(top: 100),
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

              Map prayerTimes = prayerTime.getTimes(locales, currentLang);

              return Column(
                children: [
                  if (!data['geolocation']['isGeolocated']) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(locales.dhaka),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 5),
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(geolocationProvider.notifier)
                                  .updateCoordinates(),
                              child: SvgPicture.asset(
                                'assets/images/icons/location.svg',
                                fit: BoxFit.scaleDown,
                                width: 40,
                                height: 30,
                              ),
                            ),
                          ),
                          Text(locales.setLocation)
                        ],
                      ),
                    ),
                  ],
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: NamazTimeItem(
                          label: prayerTimes['tahajjud']['title'],
                          value: prayerTimes['tahajjud']['endTime'],
                          onSelected: () => QR.to('namaz-times/tahajjud'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['fajr']['title'],
                          value: prayerTimes['fajr']['startTime'],
                          onSelected: () => QR.to('namaz-times/fajr'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['sunrise']['title'],
                          value: prayerTimes['sunrise']['time'],
                          onSelected: () => QR.to('namaz-times/sunrise'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['ishraq']['title'],
                          value: prayerTimes['ishraq']['startTime'],
                          onSelected: () => QR.to('namaz-times/ishraq'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['midday']['title'],
                          value: prayerTimes['midday']['time'],
                          onSelected: () => QR.to('namaz-times/midday'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['dhuhr']['title'],
                          value: prayerTimes['dhuhr']['startTime'],
                          onSelected: () => QR.to('namaz-times/zuhr'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['asr']['title'],
                          value: prayerTimes['asr']['startTime'],
                          onSelected: () => QR.to('namaz-times/asr'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['sunset']['title'],
                          value: prayerTimes['sunset']['time'],
                          onSelected: () => QR.to('namaz-times/sunset'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['maghrib']['title'],
                          value: prayerTimes['maghrib']['startTime'],
                          onSelected: () => QR.to('namaz-times/maghrib'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['isha']['title'],
                          value: prayerTimes['isha']['startTime'],
                          onSelected: () => QR.to('namaz-times/isha'),
                        ),
                      ),
                    ],
                  ),
                  NamazSettings(preferences: data['preferences']),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
