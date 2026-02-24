import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'current_dates.dart';
import 'current_location_prayers.dart';

class DatesPrayers extends ConsumerWidget {
  const DatesPrayers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: const CurrentDates(),
          ),
          const CurrentLocationPrayers(),
        ],
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CurrentDates(),
          CurrentLocationPrayers(),
        ],
      );
    }
  }
}
