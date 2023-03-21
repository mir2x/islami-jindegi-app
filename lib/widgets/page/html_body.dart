import 'package:flutter/material.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/objects/font_size_ratio.dart';

class PageHtmlBody extends StatelessWidget {
  const PageHtmlBody({
    super.key,
    required this.text,
    required this.fontSizeRatio,
  });

  final String text;
  final FontSizeRatio fontSizeRatio;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fontSizeRatio,
      builder: (context, ratio, child) {
        return HtmlText(
          text: text,
          fontSizeRatio: ratio,
        );
      },
    );
  }
}
