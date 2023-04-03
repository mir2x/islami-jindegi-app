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
  final int selectedValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            selectedValue == value ? ThemeColors.color1 : ThemeColors.color3,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),
      ),
      child: Text(
        label,
        style: textTheme.labelLarge?.copyWith(
          color:
              selectedValue == value ? ThemeColors.color3 : ThemeColors.color1,
        ),
      ),
      onPressed: () {
        ref.read(preferencesProvider.notifier).updateHijriAdjustment(value);
      },
    );
  }
}
