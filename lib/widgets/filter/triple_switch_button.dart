import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

class TripleSwitchButton extends ConsumerWidget {
  const TripleSwitchButton({
    super.key,
    required this.firstLabel,
    required this.secondLabel,
    required this.thirdLabel,
    required this.activateFirst,
    required this.activateSecond,
    required this.activateThird,
    required this.isFirstActive,
    required this.isSecondActive,
    required this.isThirdActive,
  });

  final String firstLabel;
  final String secondLabel;
  final String thirdLabel;
  final void Function() activateFirst;
  final void Function() activateSecond;
  final void Function() activateThird;
  final bool isFirstActive;
  final bool isSecondActive;
  final bool isThirdActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;

    var activeColor = appTheme.active;
    var inactiveColor = appTheme.cardBg;
    var activeTextColor = appTheme.appBarText;
    var inactiveTextColor = appTheme.secondaryText;

    return Container(
      decoration: BoxDecoration(
        color: appTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appTheme.divider),
        boxShadow: [
          BoxShadow(
            color: appTheme.shadow.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextButton(
              onPressed: activateFirst,
              style: TextButton.styleFrom(
                backgroundColor: isFirstActive ? activeColor : inactiveColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Text(
                firstLabel.toUpperCase(),
                style: textTheme.labelMedium?.copyWith(
                  color: isFirstActive ? activeTextColor : inactiveTextColor,
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
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Text(
                secondLabel.toUpperCase(),
                style: textTheme.labelMedium?.copyWith(
                  color: isSecondActive ? activeTextColor : inactiveTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: activateThird,
              style: TextButton.styleFrom(
                backgroundColor: isThirdActive ? activeColor : inactiveColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Text(
                thirdLabel.toUpperCase(),
                style: textTheme.labelMedium?.copyWith(
                  color: isThirdActive ? activeTextColor : inactiveTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
