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

class MasailDisplay extends ConsumerWidget {
  const MasailDisplay({
    super.key,
    required this.title,
    required this.question,
    required this.answer,
    required this.audio,
    required this.author,
    required this.downloadItem,
    required this.fontSizeRatio,
  });

  final String title;
  final String question;
  final String? answer;
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
        PageSubtitle(
          text: '${locales.question}:',
          fontSizeRatio: fontSizeRatio,
          fontWeight: FontWeight.bold,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 30),
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
            child: PageHtmlBody(
              text: answer!,
              fontSizeRatio: fontSizeRatio,
            ),
          ),
        ],
        if (audio != null) ...[
          AudioPlayerWidget(
            audio: audio!,
            album: locales.masail,
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
              if (author != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageSubtitle(
                      text: locales.author,
                      fontSizeRatio: fontSizeRatio,
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
              ],
            ],
          ),
        ),
      ],
    );
  }
}
