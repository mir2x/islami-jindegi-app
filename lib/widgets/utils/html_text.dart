import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: text,
      style: {
        'body': Style(
          color: ThemeColors().themeColor3,
          fontSize: const FontSize(16),
          lineHeight: const LineHeight(1.4),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
        ),
      },
    );
  }
}
