import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class MalfuzatItem extends ConsumerWidget {
  const MalfuzatItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.malfuzats,
      id: QR.params['id'].toString(),
      params: const {'include': 'malfuzat-author'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return MyScaffold(
          title: Text(resource.title),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PageTitle(
                  text: resource.title,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
              if (resource.malfuzatAuthor.value != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: PageSubtitle(
                    text: resource.malfuzatAuthor.value.name,
                    fontSizeRatio: fontSizeRatio,
                  ),
                ),
              ],
              if (resource.body != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: PageHtmlBody(
                    text: resource.body,
                    fontSizeRatio: fontSizeRatio,
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
              ),
            ],
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SocialShare(
                    title: resource.title,
                    subtitle: resource.malfuzatAuthor.value?.name,
                    body: resource.body,
                    link: 'malfuzat/${resource.id}',
                  ),
                  BookmarkButton(
                    type: 'Malfuzat',
                    title: resource.title,
                    link: 'malfuzat/${resource.id}',
                  ),
                ],
              ),
              FontResizer(fontSizeRatio: fontSizeRatio),
            ],
          ),
        );
      },
    );
  }
}
