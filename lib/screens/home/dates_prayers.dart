import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'current_dates.dart';
import 'current_location_prayers.dart';

class DatesPrayers extends ConsumerWidget {
  const DatesPrayers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return WithPreferences(
      builder: (context, preferences) {
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
                  color: AppTheme.backgroundColor[theme],
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
              color: AppTheme.backgroundColor[theme],
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
