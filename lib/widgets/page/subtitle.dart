import 'package:flutter/material.dart';
import 'package:native_app/objects/font_size_ratio.dart';

class PageSubtitle extends StatelessWidget {
  const PageSubtitle({
    super.key,
    required this.text,
    required this.fontSizeRatio,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final FontSizeRatio fontSizeRatio;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<double>(
      valueListenable: fontSizeRatio,
      builder: (context, ratio, child) {
        return Text(
          text,
          style: textTheme.labelLarge?.copyWith(
            fontSize: 18 * ratio,
            fontWeight: fontWeight,
          ),
        );
      },
    );
  }
}
