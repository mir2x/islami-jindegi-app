import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/colors.dart';

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

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';
        var activeColor =
            theme == 'dark' ? ThemeColors.color8 : ThemeColors.color10;
        var inactiveColor =
            theme == 'dark' ? ThemeColors.color4 : ThemeColors.color9;

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
                    borderRadius: BorderRadius.zero,
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
            Expanded(
              child: TextButton(
                onPressed: activateThird,
                style: TextButton.styleFrom(
                  backgroundColor: isThirdActive ? activeColor : inactiveColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                child: Text(
                  thirdLabel.toUpperCase(),
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
