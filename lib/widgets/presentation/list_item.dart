import 'package:flutter/material.dart';
import 'package:native_app/theme/colors.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.item,
  });

  final Widget item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ThemeColors.color7,
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      child: item,
    );
  }
}
