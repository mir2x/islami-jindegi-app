import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';

class Bayan extends ConsumerWidget {
  const Bayan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.bayans,
      id: QR.params['id'].toString(),
      params: const {'include': 'speaker'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return AppScaffold(
          onBackPressed: () async => await QR.to('bayans'),
          title: Text(locales.bayan),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Text(
                  resource.title,
                  style: textTheme.headlineMedium,
                ),
              ),
              if (resource.speaker.value != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    resource.speaker.value.name,
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
              if (resource.audio != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: AudioPlayerWidget(
                    audio: resource.audio,
                  ),
                ),
              ],
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    if (resource.location != null) ...[
                      DescriptionItem(
                        title: '${locales.location}:',
                        description: Text(
                          resource.location,
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    DescriptionItem(
                      title: '${locales.date}:',
                      description: Text(
                        formatDate(resource.publishedAt, currentLang),
                        style: textTheme.labelMedium,
                      ),
                    ),
                    if (resource.excerpt != null) ...[
                      DescriptionItem(
                        title: '${locales.topic}:',
                        description: Text(
                          resource.excerpt,
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio?['metadata']?['duration'] != null) ...[
                      DescriptionItem(
                        title: '${locales.audioDuration}:',
                        description: Text(
                          playDuration(resource.audio['metadata']['duration']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio?['metadata']?['size'] != null) ...[
                      DescriptionItem(
                        title: '${locales.audioSize}:',
                        description: Text(
                          fileSize(resource.audio['metadata']['size']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio != null) ...[
                      DownloadItem(
                        filePath: resource.audio['id'],
                        fileUrl: fileSrcUrl(resource.audio),
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
          bottomBar: BottomBar(
            children: [
              Row(
                children: [
                  SocialShare(
                    title: resource.title,
                    subtitle: resource.speaker.value?.name,
                    link: 'bayans/${resource.id}',
                  ),
                  BookmarkButton(
                    type: 'Bayan',
                    title: resource.title,
                    link: 'bayans/${resource.id}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
