import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';

class MalfuzatDisplay extends ConsumerWidget {
  const MalfuzatDisplay({
    super.key,
    required this.title,
    required this.body,
    required this.excerpt,
    required this.audio,
    required this.author,
    required this.downloadItem,
    required this.fontSizeRatio,
  });

  final String title;
  final String? body;
  final String? excerpt;
  final Map? audio;
  final String? author;
  final Widget? downloadItem;
  final FontSizeRatio fontSizeRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

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
            child: PageSubtitle(
              text: author!,
              fontSizeRatio: fontSizeRatio,
            ),
          ),
        ],
        if (body != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: PageHtmlBody(
              text: body!,
              fontSizeRatio: fontSizeRatio,
            ),
          ),
        ],
        if (audio != null) ...[
          AudioPlayerWidget(
            audio: audio!,
          ),
        ],
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              if (downloadItem != null) ...[
                downloadItem!,
              ],
              if (audio?['metadata']?['size'] != null) ...[
                DescriptionItem(
                  title: '${locales.audioSize}:',
                  description: Text(
                    fileSize(audio?['metadata']?['size']!),
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
              if (audio?['metadata']?['duration'] != null) ...[
                DescriptionItem(
                  title: '${locales.audioDuration}:',
                  description: Text(
                    playDuration(
                      audio?['metadata']?['duration']!,
                    ),
                    style: textTheme.labelMedium,
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
