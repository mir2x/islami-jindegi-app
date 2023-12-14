import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';

class BayanDisplay extends ConsumerWidget {
  const BayanDisplay({
    super.key,
    required this.title,
    required this.excerpt,
    required this.location,
    required this.audio,
    required this.speaker,
    required this.publishedAt,
    required this.downloadItem,
  });

  final String title;
  final String? excerpt;
  final String? location;
  final Map? audio;
  final String? speaker;
  final String publishedAt;
  final Widget? downloadItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Text(
            title,
            style: textTheme.headlineMedium,
          ),
        ),
        if (speaker != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Text(
              speaker!,
              style: textTheme.labelMedium,
            ),
          ),
        ],
        if (audio != null) ...[
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: AudioPlayerWidget(
              audio: audio!,
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              if (downloadItem != null) ...[
                downloadItem!,
              ],
              if (location != null) ...[
                DescriptionItem(
                  title: '${locales.location}:',
                  description: Text(
                    location!,
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
              DescriptionItem(
                title: '${locales.date}:',
                description: Text(
                  formatDate(publishedAt, currentLang),
                  style: textTheme.labelMedium,
                ),
              ),
              if (excerpt != null) ...[
                DescriptionItem(
                  title: '${locales.topic}:',
                  description: Text(
                    excerpt!,
                    style: textTheme.labelMedium,
                  ),
                ),
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
                    playDuration(audio?['metadata']?['duration']!),
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
