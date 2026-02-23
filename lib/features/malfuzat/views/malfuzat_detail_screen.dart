import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/providers/downloaded_malfuzat.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/malfuzat_providers.dart';
import 'malfuzat_display.dart';

class MalfuzatDetailScreen extends ConsumerWidget {
  const MalfuzatDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var malfuzatId = QR.params['id'].toString();
    var malfuzatQuery = ref.watch(singleMalfuzatProvider(malfuzatId));

    return malfuzatQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(malfuzatApiServiceProvider);

        Future? previousPage() async {
          if (resource.position == null) {
            await QR.to('malfuzat');
            return;
          }
          var previousResources = await api.fetchMalfuzatByPosition(
            quantity: 1,
            position: resource.position! - 1,
          );

          if (previousResources.isEmpty) {
            await QR.to('malfuzat');
          } else {
            await QR.to('malfuzat/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchMalfuzatByPosition(
            quantity: 1,
            position: resource.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await QR.to('malfuzat/${nextResources.first.id}');
          }
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastMalfuzat(resource.id);
        });

        return ResizableFont(
          storeKey: 'malfuzatFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await QR.to('malfuzat'),
              showPattern: false,
              title: Text(locales.malfuzat),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    MalfuzatDisplay(
                      title: resource.title,
                      body: resource.body,
                      excerpt: resource.excerpt,
                      audio: resource.audio,
                      author: resource.authorName,
                      fontSizeRatio: fontSizeRatio,
                      downloadItem: (resource.audio != null)
                          ? DownloadItem(
                              filePath: fileTitlePath(
                                resource.title,
                                resource.audio!['id'],
                              ),
                              fileUrl: fileSrcUrl(resource.audio),
                              downloadCallback: () async {
                                await ref.watch(
                                  createDownloadedMalfuzatProvider({
                                    'malfuzatId': resource.id,
                                    'title': resource.title,
                                    'body': resource.body,
                                    'excerpt': resource.excerpt,
                                    'audio': json.encode(resource.audio),
                                    'author': resource.authorName,
                                    'publishedAt': resource.publishedAt,
                                  }).future,
                                );
                              },
                              deleteCallback: () async {
                                await ref.watch(
                                  deleteDownloadedMalfuzatProvider(resource.id)
                                      .future,
                                );
                              },
                            )
                          : null,
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
                        subtitle: resource.authorName,
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
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'malfuzatFontRatio',
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
