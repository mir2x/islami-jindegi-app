import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class SocialShare extends StatelessWidget {
  const SocialShare({
    super.key,
    this.title,
    this.subtitle,
    this.body,
    this.link,
    this.fileLink,
  });

  final String? title;
  final String? subtitle;
  final dynamic body;
  final String? link;
  final String? fileLink;

  @override
  Widget build(BuildContext context) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        var locales = AppLocalizations.of(context)!;

        const appLink =
            'https://play.google.com/store/apps/details?id=com.islami_jindegi';

        return IconButton(
          icon: const Icon(Icons.ios_share_rounded),
          color: AppTheme.titleContrastColor[theme],
          onPressed: () async {
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

            text += '\n\n$appLink';

            await Clipboard.setData(ClipboardData(text: text));

            Share.share(
              text,
              subject: title,
            );
          },
        );
      },
    );
  }
}
