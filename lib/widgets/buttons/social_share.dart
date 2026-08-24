import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter/services.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/helpers/share_content.dart';

class SocialShare extends StatelessWidget {
  const SocialShare({
    super.key,
    this.title,
    this.subtitle,
    this.body,
    this.link,
    this.fileLink,
    this.iconColor,
    this.asButton = false,
  });

  final String? title;
  final String? subtitle;
  final dynamic body;
  final String? link;
  final String? fileLink;
  final Color? iconColor;

  /// Renders a labelled button ("Share") instead of the bare icon used in
  /// app bars. Opt-in so existing call sites keep their compact icon.
  final bool asButton;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final controlColor = isClassic ? colors.appBarBg : colors.primary;

    Future<void> onPressed() async {
      String text = '';

      if (title != null) {
        text += '$title';
      }

      if (subtitle != null) {
        text += '\n\n$subtitle';
      }

      if (body != null) {
        final document = parse(body);
        List eList = document.querySelectorAll('p,h1,h2,h3,h4,h5,h6');

        if (eList.isNotEmpty) {
          text += '\n\n';

          for (var e in eList) {
            if (e.text != '') {
              if (e.localName != 'p') {
                text += '\n';
              }

              text += '${e.text}\n\n';
            }
          }
        }
      }

      if (fileLink != null) {
        text += '\n\n${locales.file}: $fileLink';
      }

      if (link != null) {
        text += '\n\n${locales.link}: https://islamijindegi.com/$link';
      }

      text += '\n\n$appStoreShareUrl';

      // Copying is a convenience feature; do not await it because this
      // StatelessWidget's BuildContext is needed immediately for the sheet.
      Clipboard.setData(ClipboardData(text: text));

      await shareContent(context, text: text, subject: title);
    }

    if (asButton) {
      return FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: const Icon(Icons.ios_share_rounded, size: 18),
        label: Text(locales.share),
        style: FilledButton.styleFrom(
          foregroundColor: iconColor ?? controlColor,
          backgroundColor: (iconColor ?? controlColor).withValues(alpha: 0.12),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.ios_share_rounded),
      color: iconColor ?? controlColor,
      onPressed: onPressed,
    );
  }
}
