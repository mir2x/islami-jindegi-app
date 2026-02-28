import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/theme/colors.dart';
import 'package:native_app/services/prayer_alarm_service.dart';
import 'package:native_app/features/namaz_time/providers/prayer_alarm_providers.dart';

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
                prayerKey: 'fajr',
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
                prayerKey: 'dhuhr',
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
                prayerKey: 'asr',
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
                prayerKey: 'maghrib',
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
                prayerKey: 'isha',
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
    this.prayerKey,
    required this.isActive,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String? prayerKey;
  final bool isActive;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    // Check if this prayer supports alarms
    bool hasAlarm =
        prayerKey != null && PrayerAlarmService.prayerKeys.contains(prayerKey);

    // Get alarm state if applicable
    bool isAlarmEnabled = false;
    if (hasAlarm) {
      var alarmStates = ref.watch(prayerAlarmProvider);
      isAlarmEnabled = alarmStates.when(
        loading: () => false,
        error: (_, __) => false,
        data: (states) => states[prayerKey] ?? false,
      );
    }

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
                      top: hasAlarm ? 0 : 9,
                      bottom: hasAlarm ? 0 : 9,
                      left: hasAlarm ? 10 : 0,
                    ),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: textTheme.labelMedium?.copyWith(
                        color: ThemeColors.color2,
                      ),
                    ),
                  ),
                  if (hasAlarm) ...[
                    SizedBox(width: isSmallMobile ? 3 : 5),
                    IconButton(
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                      ),
                      padding: const EdgeInsets.only(top: 8, bottom: 13),
                      icon: Icon(
                        isAlarmEnabled ? Icons.alarm_on : Icons.alarm_off,
                        color: isAlarmEnabled
                            ? ThemeColors.color8
                            : ThemeColors.border,
                      ),
                      onPressed: () {
                        ref
                            .read(prayerAlarmProvider.notifier)
                            .toggleAlarm(prayerKey!, !isAlarmEnabled);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !isAlarmEnabled
                                  ? '${locales.alarmEnabled} — $label'
                                  : '${locales.alarmDisabled} — $label',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
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
