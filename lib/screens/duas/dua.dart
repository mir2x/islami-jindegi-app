import 'package:flutter/material.dart';
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
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class Dua extends ConsumerWidget {
  const Dua({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.duas,
      id: QR.params['id'].toString(),
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
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: PageHtmlBody(
                  text: resource.body,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
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
                        title: 'Audio Duration:',
                        description: Text(
                          playDuration(resource.audio['metadata']['duration']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio?['metadata']?['size'] != null) ...[
                      DescriptionItem(
                        title: 'Audio Size:',
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
                    body: resource.body,
                  ),
                  BookmarkButton(
                    type: 'Dua',
                    title: resource.title,
                    link: 'duas/${resource.id}',
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
