import 'package:flutter/material.dart';
import 'package:native_app/theme/colors.dart';

class TripleSwitchButton extends StatelessWidget {
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
  final void Function()? activateFirst;
  final void Function()? activateSecond;
  final void Function()? activateThird;
  final bool isFirstActive;
  final bool isSecondActive;
  final bool isThirdActive;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextButton(
            onPressed: activateFirst,
            style: TextButton.styleFrom(
              backgroundColor:
                  isFirstActive ? ThemeColors.color8 : ThemeColors.color4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            child: Text(
              firstLabel,
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
              backgroundColor:
                  isSecondActive ? ThemeColors.color8 : ThemeColors.color4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              secondLabel,
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
              backgroundColor:
                  isThirdActive ? ThemeColors.color8 : ThemeColors.color4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            child: Text(
              thirdLabel,
              style: textTheme.labelMedium?.copyWith(
                color: ThemeColors.color7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
