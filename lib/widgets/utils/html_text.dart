import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Html(
      data: text,
      style: {
        'body': Style.fromTextStyle(
          textTheme.bodyMedium!,
        ).copyWith(
          lineHeight: const LineHeight(1.4),
          margin: Margins.zero,
        ),
      },
    );
  }
}
