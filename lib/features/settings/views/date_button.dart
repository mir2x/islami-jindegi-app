import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/app_widget/update_data.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/app_theme_color.dart';

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
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              selectedValue == value ? colors.active : colors.highlight,
          padding: EdgeInsets.all(isSmallMobile ? 9 : 12),
          shape: const CircleBorder(),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color:
                selectedValue == value ? colors.appBarText : colors.primaryText,
          ),
        ),
        onPressed: () async {
          await ref
              .read(preferencesProvider.notifier)
              .updateHijriLocalAdjustment(value);
          ref.invalidate(hijriDateSettingsProvider);
          await updateData();
        },
      ),
    );
  }
}
