import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/features/sura/views/widgets/audio_range_selection_dialog.dart';
import 'package:native_app/features/sura/views/widgets/details_bottom_sheet.dart';
import 'package:native_app/features/sura/views/widgets/translation_selection_dialog.dart';
import 'package:native_app/features/sura/providers/sura_reciter_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';

class SuraBottomNavBar extends ConsumerWidget {
  final int totalAyahs;
  final int suraNumber;
  final VoidCallback onStartAutoScroll;
  final VoidCallback onStopAutoScroll;

  const SuraBottomNavBar({
    super.key,
    required this.totalAyahs,
    required this.suraNumber,
    required this.onStartAutoScroll,
    required this.onStopAutoScroll,
  });

  void _onNavBarTapped(int index, BuildContext context, WidgetRef ref) {
    switch (index) {
      case 0:
        showDialog(
          context: context,
          builder: (context) => const TranslatorSelectionDialog(),
        );
        break;
      case 1:
        final currentState = ref.read(showWordByWordProvider);
        ref.read(showWordByWordProvider.notifier).state = !currentState;
        break;
      case 2:
        if (totalAyahs > 0) {
          onStopAutoScroll();
          showDialog(
            context: context,
            builder: (context) => AudioRangeSelectionDialog(
              totalAyahs: totalAyahs,
              suraNumber: suraNumber,
            ),
          );
        }
        break;
      case 3:
        if (totalAyahs > 0) {
          ref.read(suraAudioPlayerProvider).stop();
          if (ref.read(isAutoScrollingProvider)) {
            onStopAutoScroll();
          } else {
            onStartAutoScroll();
          }
        }
        break;
      case 4:
        showDetailsBottomSheet(context, suraNumber: suraNumber);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
      onTap: (index) => _onNavBarTapped(index, context, ref),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'অনুবাদ'),
        BottomNavigationBarItem(
            icon: Icon(Icons.text_fields), label: 'শব্দে শব্দে'),
        BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill_outlined), label: 'অডিও শুনুন'),
        BottomNavigationBarItem(
            icon: Icon(Icons.swipe_outlined), label: 'অটো স্ক্রল'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'বিস্তারিত'),
      ],
    );
  }
}
