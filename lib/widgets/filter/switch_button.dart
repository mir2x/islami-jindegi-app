import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';

class SwitchButton extends ConsumerWidget {
  const SwitchButton({
    super.key,
    required this.firstLabel,
    required this.secondLabel,
    required this.activateFirst,
    required this.activateSecond,
    required this.isFirstActive,
    required this.isSecondActive,
  });

  final String firstLabel;
  final String secondLabel;
  final void Function() activateFirst;
  final void Function() activateSecond;
  final bool isFirstActive;
  final bool isSecondActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';
        var activeColor = AppTheme.buttonActiveColor[theme];
        var inactiveColor = AppTheme.buttonInactiveColor[theme];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                onPressed: activateFirst,
                style: TextButton.styleFrom(
                  backgroundColor: isFirstActive ? activeColor : inactiveColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                ),
                child: Text(
                  firstLabel.toUpperCase(),
                  style: textTheme.labelMedium?.copyWith(
                    color: ThemeColors.color7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: activateSecond,
                style: TextButton.styleFrom(
                  backgroundColor: isSecondActive ? activeColor : inactiveColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                child: Text(
                  secondLabel.toUpperCase(),
                  style: textTheme.labelMedium?.copyWith(
                    color: ThemeColors.color7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
