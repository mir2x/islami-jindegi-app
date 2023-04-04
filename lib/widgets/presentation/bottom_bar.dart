import 'package:flutter/material.dart';
import 'package:native_app/theme/colors.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ThemeColors.color5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Row(
          mainAxisAlignment: alignment,
          children: children,
        ),
      ),
    );
  }
}
