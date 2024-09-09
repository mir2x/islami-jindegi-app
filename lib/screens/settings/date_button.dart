import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';

class DateButton extends ConsumerWidget {
  const DateButton({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
  });

  final String label;
  final int value;
  final int? selectedValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              selectedValue == value ? ThemeColors.color1 : ThemeColors.color3,
          padding: EdgeInsets.all(isSmallMobile ? 9 : 12),
          shape: const CircleBorder(),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: selectedValue == value
                ? ThemeColors.color3
                : ThemeColors.color1,
          ),
        ),
        onPressed: () {
          if (selectedValue == value) {
            ref.read(preferencesProvider.notifier).removeHijriLocalAdjustment();
          } else {
            ref
                .read(preferencesProvider.notifier)
                .updateHijriLocalAdjustment(value);
          }
        },
      ),
    );
  }
}
