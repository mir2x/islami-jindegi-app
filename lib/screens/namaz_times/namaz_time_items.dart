import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/theme/colors.dart';

class NamazTimeItems extends ConsumerStatefulWidget {
  const NamazTimeItems({
    super.key,
    required this.currentDate,
    required this.isStartTime,
  });

  final DateTime? currentDate;
  final bool isStartTime;

  @override
  NamazTimeItemsState createState() => NamazTimeItemsState();
}

class NamazTimeItemsState extends ConsumerState<NamazTimeItems> {
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

        PrayerTime prayerTime = PrayerTime(
          coordinates: Coordinates(
            geolocation['coordinates']['latitude'],
            geolocation['coordinates']['longitude'],
          ),
          timezone: geolocation['timezone'],
          preferences: prefs,
          currentDate: widget.currentDate,
        );

        Map prayerTimes = prayerTime.getTimes(locales, currentLang);
        String currentPrayer =
            prayerTime.currentAndNextPrayerNames()['currentPrayer']!;

        String timinglabel = widget.isStartTime ? locales.starts : locales.ends;

        return Column(
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
                label: '${prayerTimes['fajr']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['fajr']['startTime']
                    : prayerTimes['fajr']['endTime'],
                alarmTime: prayerTimes['fajr']['startDateTime'],
                alarmLabel: '${prayerTimes['fajr']['title']} ${locales.starts}',
                isActive: currentPrayer == 'fajr',
                onSelected: () => QR.to('namaz-times/fajr'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['sunrise']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['sunrise']['startTime']
                    : prayerTimes['sunrise']['endTime'],
                alarmTime: prayerTimes['sunrise']['startDateTime'],
                alarmLabel:
                    '${prayerTimes['sunrise']['title']} ${locales.starts}',
                isActive: false,
                onSelected: () => QR.to('namaz-times/sunrise'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['ishraq']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['ishraq']['startTime']
                    : prayerTimes['ishraq']['endTime'],
                alarmTime: prayerTimes['ishraq']['startDateTime'],
                alarmLabel:
                    '${prayerTimes['ishraq']['title']} ${locales.starts}',
                isActive: currentPrayer == 'ishraq',
                onSelected: () => QR.to('namaz-times/ishraq'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['midday']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['midday']['startTime']
                    : prayerTimes['midday']['endTime'],
                alarmTime: prayerTimes['midday']['startDateTime'],
                alarmLabel:
                    '${prayerTimes['midday']['title']} ${locales.starts}',
                isActive: false,
                onSelected: () => QR.to('namaz-times/midday'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['dhuhr']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['dhuhr']['startTime']
                    : prayerTimes['dhuhr']['endTime'],
                alarmTime: prayerTimes['dhuhr']['startDateTime'],
                alarmLabel:
                    '${prayerTimes['dhuhr']['title']} ${locales.starts}',
                isActive: currentPrayer == 'dhuhr',
                onSelected: () => QR.to('namaz-times/zuhr'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['asr']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['asr']['startTime']
                    : prayerTimes['asr']['endTime'],
                alarmTime: prayerTimes['asr']['startDateTime'],
                alarmLabel: '${prayerTimes['asr']['title']} ${locales.starts}',
                isActive: currentPrayer == 'asr',
                onSelected: () => QR.to('namaz-times/asr'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['sunset']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['sunset']['startTime']
                    : prayerTimes['sunset']['endTime'],
                alarmTime: prayerTimes['sunset']['startDateTime'],
                alarmLabel:
                    '${prayerTimes['sunset']['title']} ${locales.starts}',
                isActive: false,
                onSelected: () => QR.to('namaz-times/sunset'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['maghrib']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['maghrib']['startTime']
                    : prayerTimes['maghrib']['endTime'],
                alarmTime: prayerTimes['maghrib']['startDateTime'],
                alarmLabel:
                    '${prayerTimes['maghrib']['title']} ${locales.starts}',
                isActive: currentPrayer == 'maghrib',
                onSelected: () => QR.to('namaz-times/maghrib'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: NamazTimeItem(
                label: '${prayerTimes['isha']['title']} $timinglabel',
                value: widget.isStartTime
                    ? prayerTimes['isha']['startTime']
                    : prayerTimes['isha']['endTime'],
                alarmTime: prayerTimes['isha']['startDateTime'],
                alarmLabel: '${prayerTimes['isha']['title']} ${locales.starts}',
                isActive: currentPrayer == 'isha',
                onSelected: () => QR.to('namaz-times/isha'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NamazTimeItem extends ConsumerWidget {
  const NamazTimeItem({
    super.key,
    required this.label,
    required this.value,
    this.alarmTime,
    this.alarmLabel,
    required this.isActive,
    required this.onSelected,
  });

  final String label;
  final String value;
  final DateTime? alarmTime;
  final String? alarmLabel;
  final bool isActive;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    bool alarmable =
        Platform.isAndroid && alarmTime != null && alarmLabel != null;

    return Row(
      children: [
        Expanded(
          flex: 7,
          child: InkWell(
            onTap: onSelected,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isActive ? ThemeColors.color5 : ThemeColors.color7,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallMobile ? 8 : 12,
                vertical: isSmallMobile ? 10 : 12,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(
                  color: ThemeColors.color3,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: isSmallMobile ? 8 : 10),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: onSelected,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ThemeColors.color3,
                border: Border.all(
                  color: ThemeColors.color2,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: isSmallMobile ? 0 : 2,
                horizontal: isSmallMobile ? 3 : 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: alarmable ? 0 : 9,
                      bottom: alarmable ? 0 : 9,
                      left: alarmable ? 10 : 0,
                    ),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: textTheme.labelMedium?.copyWith(
                        color: ThemeColors.color2,
                      ),
                    ),
                  ),
                  if (alarmable) ...[
                    SizedBox(width: isSmallMobile ? 3 : 5),
                    IconButton(
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                      ),
                      icon: const Icon(
                        Icons.add_alarm,
                      ),
                      onPressed: () async {
                        FlutterAlarmClock.createAlarm(
                          hour: alarmTime!.hour,
                          minutes: alarmTime!.minute,
                          title: alarmLabel!,
                          skipUi: false,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
