import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhan/adhan.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/preferences.dart';
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
    required this.isActive,
    required this.onSelected,
  });

  final String label;
  final String value;
  final bool isActive;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var prefs = ref.watch(preferencesProvider);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: prefs.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => Text(error.toString()),
            data: (preferences) {
              String theme = preferences.getString('theme') ?? 'dark';

              return InkWell(
                onTap: onSelected,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isActive ? ThemeColors.color5 : ThemeColors.color7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: textTheme.labelMedium?.copyWith(
                      color: theme == 'light' ? ThemeColors.color3 : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(
                  color: ThemeColors.color2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
