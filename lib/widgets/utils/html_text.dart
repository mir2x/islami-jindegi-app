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
    this.selectable = true,
  });

  final String text;
  final double fontSizeRatio;
  final double arabicFontScale;

  /// Whether this body owns its own [SelectionArea].
  ///
  /// Set false when an ancestor already provides one — nesting selection
  /// areas breaks drag selection. [LazyItemContent] renders one block per
  /// sliver under a single shared [SelectionArea], so its blocks pass false.
  final bool selectable;

  // An absolute `font-size` inside a `style` attribute or an embedded
  // <style> block. flutter_html reads every length unit as px (14pt renders
  // as 14px), so the unit is matched only to be kept.
  static final _inlineFontSize = RegExp(
    r'font-size\s*:\s*([\d.]+)\s*(px|pt)',
    caseSensitive: false,
  );

  /// Editor content often arrives with sizes baked in as inline CSS. The
  /// `style` map below is applied after inline CSS, but only to tags it has
  /// an entry for — a `<span style="font-size: 26px">` or a sized `<div>`
  /// keeps its own size and never followed the reader's font control (a
  /// malfuzat's title grew while its body did not). Rewriting the values
  /// keeps the author's relative sizes and scales them with the rest.
  String _scaleInlineFontSizes(String html) {
    return html.replaceAllMapped(_inlineFontSize, (match) {
      final size = double.parse(match[1]!) * fontSizeRatio;
      return 'font-size: ${size.toStringAsFixed(2)}${match[2]}';
    });
  }

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

    final html = RepaintBoundary(
      child: Html(
        // No key is needed to pick up a new fontSizeRatio: `Html` mints a
        // fresh GlobalKey for its HtmlParser every time it is constructed, so
        // each rebuild here already remounts the parser and recomputes the
        // style tree (flutter_html 3.0.0, _HtmlState.build).
        data: _scaleInlineFontSizes(text),
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
          // The root inherits DefaultTextStyle, which the ratio never
          // touches. Sizing `body` makes text outside the tags styled below
          // — a bare <div>, <span> or <li> — scale too, by inheritance.
          'body': Style(
            margin: Margins.zero,
            fontSize: FontSize(17 * fontSizeRatio),
            lineHeight: const LineHeight(1.45),
          ),
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

    return selectable ? SelectionArea(child: html) : html;
  }
}
