import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/dua_providers.dart';

class DuaDetailScreen extends ConsumerWidget {
  const DuaDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var duaId = QR.params['id'].toString();
    var duaQuery = ref.watch(singleDuaProvider(duaId));

    return duaQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(duaApiServiceProvider);

        Future? previousPage() async {
          if (resource.position == null) {
            await QR.to('duas');
            return;
          }
          var previousResources = await api.fetchDuasByPosition(
            quantity: 1,
            position: resource.position! - 1,
          );

          if (previousResources.isEmpty) {
            await QR.to('duas');
          } else {
            await QR.to('duas/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchDuasByPosition(
            quantity: 1,
            position: resource.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await QR.to('duas/${nextResources.first.id}');
          }
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastDuaDurud(resource.id);
        });

        return ResizableFont(
          storeKey: 'duaFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await QR.to('duas'),
              showPattern: false,
              title: Text(locales.duaDurud),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
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
                      AudioPlayerWidget(
                        audio: resource.audio!,
                        album: locales.duaDurud,
                        title: resource.title,
                      ),
                    ],
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          if (resource.audio != null) ...[
                            DownloadItem(
                              filePath: fileTitlePath(
                                resource.title,
                                resource.audio!['id'],
                              ),
                              fileUrl: fileSrcUrl(resource.audio),
                            ),
                          ],
                          if (resource.audio?['metadata']?['size'] != null) ...[
                            DescriptionItem(
                              title: '${locales.audioSize}:',
                              description: Text(
                                fileSize(resource.audio!['metadata']['size']),
                                style: textTheme.labelMedium,
                              ),
                            ),
                          ],
                          if (resource.audio?['metadata']?['duration'] !=
                              null) ...[
                            DescriptionItem(
                              title: '${locales.audioDuration}:',
                              description: Text(
                                playDuration(
                                  resource.audio!['metadata']['duration'],
                                ),
                                style: textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Previous(onPrevious: previousPage),
                  Row(
                    children: [
                      SocialShare(
                        title: resource.title,
                        body: resource.body,
                        link: 'duas/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'Dua',
                        title: resource.title,
                        link: 'duas/${resource.id}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'duaFontRatio',
                  ),
                  Next(onNext: nextPage),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
