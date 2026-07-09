import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'audio_player.dart';

class MasailDisplay extends ConsumerWidget {
  const MasailDisplay({
    super.key,
    required this.masailId,
    required this.title,
    required this.question,
    required this.answer,
    required this.audioUrl,
    required this.author,
    required this.downloadItem,
    required this.fontSizeRatio,
  });

  final String masailId;
  final String title;
  final String question;
  final String? answer;
  final String? audioUrl;
  final String? author;
  final Widget? downloadItem;
  final FontSizeRatio fontSizeRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: PageTitle(
            text: title,
            fontSizeRatio: fontSizeRatio,
          ),
        ),
        PageSubtitle(
          text: '${locales.question}:',
          fontSizeRatio: fontSizeRatio,
          fontWeight: FontWeight.bold,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 30),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appTheme.highlight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appTheme.divider),
          ),
          child: PageHtmlBody(
            text: question,
            fontSizeRatio: fontSizeRatio,
          ),
        ),
        PageSubtitle(
          text: '${locales.answer}:',
          fontSizeRatio: fontSizeRatio,
          fontWeight: FontWeight.bold,
        ),
        if (answer != null) ...[
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appTheme.divider),
            ),
            child: PageHtmlBody(
              text: answer!,
              fontSizeRatio: fontSizeRatio,
            ),
          ),
        ],
        if (audioUrl != null) ...[
          MasailAudioPlayer(
            masailId: masailId,
            audioUrl: audioUrl!,
            title: title,
          ),
        ],
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              if (downloadItem != null) ...[
                downloadItem!,
              ],
              if (author != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appTheme.highlight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appTheme.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageSubtitle(
                        text: locales.author,
                        fontSizeRatio: fontSizeRatio,
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: PageSubtitle(
                          text: author!,
                          fontSizeRatio: fontSizeRatio,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
