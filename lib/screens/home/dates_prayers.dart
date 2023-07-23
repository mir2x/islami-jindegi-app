import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';
import 'current_dates.dart';
import 'current_location_prayers.dart';

class DatesPrayers extends ConsumerWidget {
  const DatesPrayers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 8,
                ),
                child: const CurrentDates(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:
                      theme == 'dark' ? ThemeColors.color2 : ThemeColors.color3,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 15,
                ),
                child: const CurrentLocationPrayers(),
              ),
            ],
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: theme == 'dark' ? ThemeColors.color2 : ThemeColors.color3,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrentDates(),
                CurrentLocationPrayers(),
              ],
            ),
          );
        }
      },
    );
  }
}
