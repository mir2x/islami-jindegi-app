import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    super.key,
    required this.text,
    this.fontSizeRatio = 1.0,
    this.arabicFontScale = 1.0,
  });

  final String text;
  final double fontSizeRatio;
  final double arabicFontScale;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;

    Style hx = Style.fromTextStyle(
      textTheme.headlineLarge!,
    ).copyWith(
      lineHeight: const LineHeight(1.45),
      margin: Margins.zero,
      fontSize: FontSize(24 * fontSizeRatio),
    );

    return SelectionArea(
      child: Html(
        data: text,
        extensions: [
          ImageExtension(
            builder: (extensionContext) {
              String src = extensionContext.attributes['src']!;
              return CachedNetworkImage(imageUrl: src);
            },
          ),
          TagWrapExtension(
            tagsToWrap: {'table'},
            builder: (child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1000,
                  child: child,
                ),
              );
            },
          ),
          const TableHtmlExtension(),
          MatcherExtension(
            matcher: (p0) {
              var parent = p0.element?.parent?.localName;
              return ['th', 'td'].contains(parent);
            },
            builder: (extensionContext) {
              return Text(
                extensionContext.element!.text,
                style: TextStyle(
                  fontSize: 17 * fontSizeRatio,
                ),
              );
            },
          ),
        ],
        onLinkTap: (String? url, _, __) async {
          if (url != null) {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $url';
            }
          }
        },
        style: {
          'body': Style(margin: Margins.zero),
          'h6': Style.fromTextStyle(
            textTheme.bodyMedium!,
          ).copyWith(
            lineHeight: const LineHeight(1.45),
            margin: Margins.zero,
            fontSize: FontSize(17 * fontSizeRatio),
          ),
          'h5': Style.fromTextStyle(
            textTheme.headlineMedium!,
          ).copyWith(
            lineHeight: const LineHeight(1.45),
            margin: Margins.zero,
            fontSize: FontSize(20 * fontSizeRatio),
          ),
          'h4': hx,
          'h3': hx,
          'h2': hx,
          'h1': hx,
          'p': Style.fromTextStyle(
            textTheme.bodyMedium!,
          ).copyWith(
            lineHeight: const LineHeight(1.45),
            margin: Margins.only(bottom: 16),
            fontSize: FontSize(17 * fontSizeRatio),
            color: appTheme.primaryText,
          ),
          'a': Style(
            color: appTheme.active,
            textDecoration: TextDecoration.none,
          ),
          'th': Style(
            textAlign: TextAlign.start,
            padding: HtmlPaddings.all(10),
            backgroundColor: appTheme.highlight,
            border: Border.all(
              color: appTheme.divider,
              width: 0.5,
            ),
          ),
          'td': Style(
            padding: HtmlPaddings.all(10),
            border: Border.all(
              color: appTheme.divider,
              width: 0.5,
            ),
          ),
          '.tiptap-sm-font': Style(fontSize: FontSize(14 * fontSizeRatio)),
          '.tiptap-md-font': Style(fontSize: FontSize(17 * fontSizeRatio)),
          '.tiptap-lg-font': Style(fontSize: FontSize(20 * fontSizeRatio)),
          '.tiptap-xl-font': Style(fontSize: FontSize(24 * fontSizeRatio)),
          '[dir="rtl"]': Style(
            direction: TextDirection.rtl,
            textAlign: TextAlign.right,
            fontSize: FontSize(20 * fontSizeRatio * arabicFontScale),
            lineHeight: const LineHeight(1.7),
          ),
        },
      ),
    );
  }
}
