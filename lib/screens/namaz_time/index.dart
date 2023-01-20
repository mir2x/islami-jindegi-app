import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/providers/settings.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'item.dart';

class NamazTime extends ConsumerWidget {
  const NamazTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(settingsProvider);

    return MyScaffold(
      title: const Text('Namaz Time'),
      body: ItemContent(
        children: [
          Center(
            child: HijriDate(),
          ),
          prefs.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Text(error.toString()),
            data: (preferences) {
              return StatefulNamazTime(preferences: preferences);
            },
          ),
        ],
      ),
    );
  }
}

class StatefulNamazTime extends ConsumerStatefulWidget {
  const StatefulNamazTime({
    super.key,
    required this.preferences,
  });

  final dynamic preferences;

  @override
  NamazTimeState createState() => NamazTimeState();
}

class NamazTimeState extends ConsumerState<StatefulNamazTime> {
  Map? prayerTimes;
  String time = 'tahajjud';

  @override
  void initState() {
    super.initState();

    var coordinates = Coordinates(23.8103, 90.4125);

    PrayerTime prayerTime = PrayerTime(
      coordinates: coordinates,
      preferences: widget.preferences,
    );

    prayerTimes = prayerTime.getTimes();
  }

  updateTime(String value) {
    setState(() {
      time = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.namazTimes,
      params: {'slug': time, 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: NamazTimeItem(
            label: prayerTimes!['tahajjud']['title'],
            value: prayerTimes!['tahajjud']['endTime'],
            isSelected: time == 'tahajjud',
            onSelected: () => updateTime('tahajjud'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['fajr']['title'],
            value: prayerTimes!['fajr']['startTime'],
            isSelected: time == 'fajr',
            onSelected: () => updateTime('fajr'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['sunrise']['title'],
            value: prayerTimes!['sunrise']['time'],
            isSelected: time == 'sunrise',
            onSelected: () => updateTime('sunrise'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['ishraq']['title'],
            value: prayerTimes!['ishraq']['startTime'],
            isSelected: time == 'ishraq',
            onSelected: () => updateTime('ishraq'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['midday']['title'],
            value: prayerTimes!['midday']['time'],
            isSelected: time == 'midday',
            onSelected: () => updateTime('midday'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['dhuhr']['title'],
            value: prayerTimes!['dhuhr']['startTime'],
            isSelected: time == 'zuhr',
            onSelected: () => updateTime('zuhr'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['asr']['title'],
            value: prayerTimes!['asr']['startTime'],
            isSelected: time == 'asr',
            onSelected: () => updateTime('asr'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['sunset']['title'],
            value: prayerTimes!['sunset']['time'],
            isSelected: time == 'sunset',
            onSelected: () => updateTime('sunset'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['maghrib']['title'],
            value: prayerTimes!['maghrib']['startTime'],
            isSelected: time == 'maghrib',
            onSelected: () => updateTime('maghrib'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NamazTimeItem(
            label: prayerTimes!['isha']['title'],
            value: prayerTimes!['isha']['startTime'],
            isSelected: time == 'isha',
            onSelected: () => updateTime('isha'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: modelQuery.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) => ModelExeptionHandler(error: error),
            data: (resources) {
              var item = resources[0];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Masail',
                      style: textTheme.headlineMedium,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: HtmlText(
                      text: item.masail,
                    ),
                  ),
                  if (item.fazail != null) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Text(
                        'Fazail',
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: HtmlText(
                        text: item.fazail,
                      ),
                    ),
                  ] else
                    ...[],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
