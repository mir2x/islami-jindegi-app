import 'package:flutter/material.dart';
import 'package:native_app/objects/font_size_ratio.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    required this.text,
    required this.fontSizeRatio,
  });

  final String text;
  final FontSizeRatio fontSizeRatio;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<double>(
      valueListenable: fontSizeRatio,
      builder: (context, ratio, child) {
        return SelectableText(
          text,
          style: textTheme.headlineLarge?.copyWith(
            fontSize: 24 * ratio,
          ),
        );
      },
    );
  }
}
