import 'package:flutter/material.dart';
import 'package:native_app/theme/colors.dart';

class NamazTimeItem extends StatelessWidget {
  const NamazTimeItem({
    super.key,
    required this.label,
    required this.value,
    required this.onSelected,
  });

  final String label;
  final String value;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: onSelected,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ThemeColors.color7,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: onSelected,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ThemeColors.color3,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(
                  color: ThemeColors.color2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
