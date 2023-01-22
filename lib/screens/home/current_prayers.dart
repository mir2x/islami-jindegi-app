import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/providers/settings.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/theme/colors.dart';

class CurrentPrayers extends ConsumerWidget {
  const CurrentPrayers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var prefs = ref.watch(settingsProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ThemeColors.color2,
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 12),
      child: prefs.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Text(error.toString()),
        data: (SharedPreferences preferences) {
          var coordinates = Coordinates(23.8103, 90.4125);

          PrayerTime prayerTime = PrayerTime(
            coordinates: coordinates,
            preferences: preferences,
          );

          Map prayerTimes = prayerTime.getCurrentAndNextPrayers();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prayerTimes.containsKey('current')) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${prayerTimes['current']['title']}',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${prayerTimes['current']['time']}',
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ] else
                ...[],
              const SizedBox(height: 5),
              Text(
                'next ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}',
                style: textTheme.labelSmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
