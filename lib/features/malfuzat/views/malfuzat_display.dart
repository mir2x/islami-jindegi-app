import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'audio_player.dart';

class MalfuzatDisplay extends ConsumerWidget {
  const MalfuzatDisplay({
    super.key,
    required this.malfuzatId,
    required this.title,
    required this.body,
    required this.excerpt,
    required this.audioUrl,
    required this.author,
    required this.downloadItem,
    required this.fontSizeRatio,
  });

  final String malfuzatId;
  final String title;
  final String? body;
  final String? excerpt;
  final String? audioUrl;
  final String? author;
  final Widget? downloadItem;
  final FontSizeRatio fontSizeRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        if (author != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: appTheme.highlight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appTheme.divider),
            ),
            child: PageSubtitle(
              text: author!,
              fontSizeRatio: fontSizeRatio,
            ),
          ),
        ],
        if (body != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appTheme.divider),
            ),
            child: PageHtmlBody(
              text: body!,
              fontSizeRatio: fontSizeRatio,
            ),
          ),
        ],
        if (audioUrl != null) ...[
          MalfuzatAudioPlayerWidget(
            malfuzatId: malfuzatId,
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
            ],
          ),
        ),
      ],
    );
  }
}
