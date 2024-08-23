import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';

class DayLightSwitch extends ConsumerStatefulWidget {
  const DayLightSwitch({
    super.key,
    required this.preferences,
  });

  final dynamic preferences;

  @override
  DayLightSwitchState createState() => DayLightSwitchState();
}

class DayLightSwitchState extends ConsumerState<DayLightSwitch> {
  toggleTime(bool value) {
    setState(() {
      widget.preferences.setBool('daylight', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String theme = widget.preferences.getString('theme') ?? 'classic';

    bool selectedDayLight = widget.preferences.getBool('daylight') ?? false;

    return AnimatedToggleSwitch<bool>.dual(
      current: selectedDayLight,
      first: true,
      second: false,
      spacing: 40,
      style: const ToggleStyle(
        borderColor: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      borderWidth: 5,
      height: 36,
      onChanged: (b) => toggleTime(b),
      indicatorSize: const Size.fromWidth(26),
      styleBuilder: (b) => ToggleStyle(
        backgroundColor: AppTheme.backgroundColor[theme],
        indicatorColor: b ? AppTheme.iconColor[theme] : ThemeColors.danger,
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
