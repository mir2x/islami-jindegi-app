import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:native_app/providers/preferences.dart';

class DayLightSwitch extends ConsumerWidget {
  const DayLightSwitch({
    super.key,
    required this.preferences,
  });

  final dynamic preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    bool selectedDayLight = preferences.getBool('daylight') ?? false;

    return AnimatedToggleSwitch<bool>.dual(
      current: selectedDayLight,
      first: true,
      second: false,
      spacing: 40,
      style: ToggleStyle(
        borderColor: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.26),
            blurRadius: 4.0,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      borderWidth: 5,
      height: 36,
      onChanged: (b) =>
          ref.read(preferencesProvider.notifier).updateDaylight(b),
      indicatorSize: const Size.fromWidth(26),
      styleBuilder: (b) => ToggleStyle(
        backgroundColor: colorScheme.surface,
        indicatorColor: b ? colorScheme.onSurfaceVariant : colorScheme.error,
      ),
      textBuilder: (value) => value
          ? Center(
              child: Text(
                locales.yes,
                style: textTheme.labelMedium,
              ),
            )
          : Center(
              child: Text(
                locales.no,
                style: textTheme.labelMedium,
              ),
            ),
    );
  }
}
