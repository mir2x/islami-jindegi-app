import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/widgets/calendar/gregorian_date.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'hijri_date_calendar.dart';
import 'item.dart';

class NamazTimes extends ConsumerStatefulWidget {
  const NamazTimes({super.key});

  @override
  NamazTimesState createState() => NamazTimesState();
}

class NamazTimesState extends ConsumerState<NamazTimes> {
  HijriCalendar? selectedHijriDate;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => setState(() {}),
    );
  }

  updateHijriDate(HijriCalendar value) {
    setState(() {
      selectedHijriDate = value;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var dataProvider = ref.watch(preferencesAndGeolocationProvider);

    return AppScaffold(
      title: Text(locales.namazTime),
      body: dataProvider.when(
        loading: () => Container(
          margin: const EdgeInsets.only(top: 100),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(error.toString()),
        data: (Map data) {
          final prefs = data['preferences'];
          Map geolocation = data['geolocation'];

          DateTime? currentGregorianDate;

          if (selectedHijriDate != null) {
            int adjustment = prefs.getInt('hijriAdjustment') ?? 0;

            currentGregorianDate = HijriCalendar().hijriToGregorian(
              selectedHijriDate!.hYear,
              selectedHijriDate!.hMonth,
              selectedHijriDate!.hDay - adjustment,
            );
          }

          PrayerTime prayerTime = PrayerTime(
            coordinates: Coordinates(
              geolocation['coordinates']['latitude'],
              geolocation['coordinates']['longitude'],
            ),
            preferences: prefs,
            currentDate: currentGregorianDate,
          );

          Map prayerTimes = prayerTime.getTimes(locales, currentLang);
          String currentPrayer =
              prayerTime.currentAndNextPrayerNames()['currentPrayer']!;

          String location = [
            geolocation['location']['city'],
            geolocation['location']['country']
          ].where((v) => v is String && v.isNotEmpty).join(', ');

          return ItemContent(
            children: [
              Column(
                children: [
                  HijriDateCalendar(
                    currentDate: selectedHijriDate,
                    onUpdate: updateHijriDate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HijriDate(currentDate: selectedHijriDate),
                        const SizedBox(width: 15),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GregorianDate(currentDate: currentGregorianDate),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(location, style: textTheme.labelSmall),
                          if (!geolocation['isGeolocated']) ...[
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 5,
                              ),
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
                            Text(
                              locales.setLocation,
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => QR.to('namaz-times/settings'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['tahajjud']['title'],
                          value: prayerTimes['tahajjud']['endTime'],
                          isActive: currentPrayer == 'tahajjud',
                          onSelected: () => QR.to('namaz-times/tahajjud'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['fajr']['title'],
                          value: prayerTimes['fajr']['startTime'],
                          isActive: currentPrayer == 'fajr',
                          onSelected: () => QR.to('namaz-times/fajr'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['sunrise']['title'],
                          value: prayerTimes['sunrise']['time'],
                          isActive: false,
                          onSelected: () => QR.to('namaz-times/sunrise'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['ishraq']['title'],
                          value: prayerTimes['ishraq']['startTime'],
                          isActive: currentPrayer == 'ishraq',
                          onSelected: () => QR.to('namaz-times/ishraq'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['midday']['title'],
                          value: prayerTimes['midday']['time'],
                          isActive: false,
                          onSelected: () => QR.to('namaz-times/midday'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['dhuhr']['title'],
                          value: prayerTimes['dhuhr']['startTime'],
                          isActive: currentPrayer == 'dhuhr',
                          onSelected: () => QR.to('namaz-times/zuhr'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['asr']['title'],
                          value: prayerTimes['asr']['startTime'],
                          isActive: currentPrayer == 'asr',
                          onSelected: () => QR.to('namaz-times/asr'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['sunset']['title'],
                          value: prayerTimes['sunset']['time'],
                          isActive: false,
                          onSelected: () => QR.to('namaz-times/sunset'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['maghrib']['title'],
                          value: prayerTimes['maghrib']['startTime'],
                          isActive: currentPrayer == 'maghrib',
                          onSelected: () => QR.to('namaz-times/maghrib'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: NamazTimeItem(
                          label: prayerTimes['isha']['title'],
                          value: prayerTimes['isha']['startTime'],
                          isActive: currentPrayer == 'isha',
                          onSelected: () => QR.to('namaz-times/isha'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
