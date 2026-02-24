import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/providers/downloaded_masail.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/masail_providers.dart';
import 'masail_display.dart';

class MasailDetailScreen extends ConsumerWidget {
  const MasailDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var masailId = QR.params['id'].toString();
    var masailQuery = ref.watch(singleMasailProvider(masailId));

    return masailQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(masailApiServiceProvider);

        Future? previousPage() async {
          if (resource.position == null) {
            await QR.to('masail');
            return;
          }
          var previousResources = await api.fetchMasailByPosition(
            quantity: 1,
            position: resource.position! - 1,
          );

          if (previousResources.isEmpty) {
            await QR.to('masail');
          } else {
            await QR.to('masail/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchMasailByPosition(
            quantity: 1,
            position: resource.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await QR.to('masail/${nextResources.first.id}');
          }
        }

        Future(() {
          ref.read(lastVisitedProvider.notifier).updateLastMasail(resource.id);
        });

        return ResizableFont(
          storeKey: 'masailFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await QR.to('masail'),
              showPattern: false,
              title: Text(locales.masail),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    MasailDisplay(
                      title: resource.title,
                      question: resource.question,
                      answer: resource.answer,
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
                                  createDownloadedMasailProvider({
                                    'masailId': resource.id,
                                    'title': resource.title,
                                    'question': resource.question,
                                    'answer': resource.answer,
                                    'audio': json.encode(resource.audio),
                                    'author': resource.authorName,
                                    'publishedAt': resource.publishedAt,
                                  }).future,
                                );
                              },
                              deleteCallback: () async {
                                await ref.watch(
                                  deleteDownloadedMasailProvider(resource.id)
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
                        body: '${resource.question} \n\n${resource.answer}',
                        link: 'masail/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'Masail',
                        title: resource.title,
                        link: 'masail/${resource.id}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'masailFontRatio',
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
