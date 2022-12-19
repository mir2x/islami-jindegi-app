import 'package:flutter/material.dart';
import 'package:native_app/theme/colors.dart';

class FilterListItem extends StatelessWidget {
  const FilterListItem({
    super.key,
    required this.item,
  });

  final Widget item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColors.color4,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: item,
    );
  }
}
