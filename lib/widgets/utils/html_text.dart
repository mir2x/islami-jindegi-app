import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    super.key,
    required this.text,
    this.fontSizeRatio = 1.0,
  });

  final String text;
  final double fontSizeRatio;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    Style bodySmall = Style.fromTextStyle(
      textTheme.bodySmall!,
    ).copyWith(
      lineHeight: const LineHeight(1.45),
      margin: Margins.zero,
      fontSize: FontSize(14 * fontSizeRatio),
    );

    Style bodyMedium = Style.fromTextStyle(
      textTheme.bodyMedium!,
    ).copyWith(
      lineHeight: const LineHeight(1.45),
      margin: Margins.zero,
      fontSize: FontSize(17 * fontSizeRatio),
    );

    Style bodyLarge = Style.fromTextStyle(
      textTheme.headlineMedium!,
    ).copyWith(
      lineHeight: const LineHeight(1.45),
      margin: Margins.zero,
      fontSize: FontSize(20 * fontSizeRatio),
    );

    Style bodyExtraLarge = Style.fromTextStyle(
      textTheme.headlineLarge!,
    ).copyWith(
      lineHeight: const LineHeight(1.45),
      margin: Margins.zero,
      fontSize: FontSize(24 * fontSizeRatio),
    );

    Style paragraph = Style.fromTextStyle(
      textTheme.bodyMedium!,
    ).copyWith(
      lineHeight: const LineHeight(1.45),
      margin: Margins.only(bottom: 16),
      fontSize: FontSize(17 * fontSizeRatio),
    );

    return Html(
      data: text,
      extensions: [
        ImageExtension(
          builder: (extensionContext) {
            String src = extensionContext.attributes['src']!;
            return CachedNetworkImage(imageUrl: src);
          },
        ),
      ],
      onLinkTap: (String? strUrl, attributes, __) async {
        if (strUrl != null) {
          final url = Uri.parse(strUrl);
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      style: {
        'body': bodyMedium,
        'h6': bodyMedium,
        'h5': bodyLarge,
        'h4': bodyExtraLarge,
        'h3': bodyExtraLarge,
        'h2': bodyExtraLarge,
        'h1': bodyExtraLarge,
        'p': paragraph,
        '.tiptap-sm-font': bodySmall,
        '.tiptap-md-font': bodyMedium,
        '.tiptap-lg-font': bodyLarge,
        '.tiptap-xl-font': bodyExtraLarge,
        '[dir="rtl"]': Style(
          direction: TextDirection.rtl,
        ),
      },
    );
  }
}
