import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/core/navigation/offline_sibling_query.dart';
import 'package:native_app/core/navigation/sibling_ref.dart';
import '../providers/masail_providers.dart';
import '../models/masail.dart';
import 'masail_display.dart';

class MasailDetailScreen extends ConsumerWidget {
  const MasailDetailScreen({super.key});

  Future<SiblingRef?> _sibling(
    WidgetRef ref,
    MasailItem current, {
    required bool forward,
  }) async {
    final embedded = forward ? current.next : current.previous;
    if (embedded != null) return embedded;
    if (!current.isOffline) return null;
    if (current.position == null) return null;
    final db = await ref.read(masailOfflineServiceProvider).database;
    return findOfflineSibling(
        db: db,
        table: 'masails',
        position: current.position!,
        id: current.id,
        forward: forward,
        descending: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var masailId = GoRouterState.of(context).pathParameters['id'].toString();
    var masailQuery = ref.watch(singleMasailProvider(masailId));

    return masailQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          final previous = await _sibling(ref, resource, forward: false);
          if (!context.mounted) return;
          context.go(previous == null ? '/masail' : '/masail/${previous.id}');
        }

        Future? nextPage() async {
          final next = await _sibling(ref, resource, forward: true);
          if (!context.mounted || next == null) return;
          context.go('/masail/${next.id}');
        }

        Future(() {
          ref.read(lastVisitedProvider.notifier).updateLastMasail(resource.id);
        });

        return ResizableFont(
          storeKey: 'masailFontRatio',
          builder: (context, fontSizeRatio) {
            final filePath = resource.audioUrl != null
                ? fileTitlePath(resource.title, 'masails/${resource.id}')
                : null;

            return AppScaffold(
              onBackPressed: () async =>
                  context.canPop() ? context.pop() : context.go('/masail'),
              showPattern: false,
              title: Text(locales.masail),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    MasailDisplay(
                      masailId: resource.id,
                      title: resource.title,
                      question: resource.question ?? '',
                      answer: resource.answer,
                      audioUrl: resource.audioUrl,
                      author: resource.authorName,
                      fontSizeRatio: fontSizeRatio,
                      downloadItem: (resource.audioUrl != null &&
                              filePath != null)
                          ? DownloadItem(
                              filePath: filePath,
                              fileUrl: resource.audioUrl!,
                              downloadCallback: () async {
                                await ref.watch(
                                  createDownloadedMasailProvider({
                                    'masailId': resource.id,
                                    'title': resource.title,
                                    'question': resource.question,
                                    'answer': resource.answer,
                                    'audio': resource.audioUrl,
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
                  Previous(
                    onPrevious: previousPage,
                    resolveDisabledKey: resource.id,
                    resolveDisabled: () async =>
                        await _sibling(ref, resource, forward: false) == null,
                  ),
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
                  Next(
                    onNext: nextPage,
                    resolveDisabledKey: resource.id,
                    resolveDisabled: () async =>
                        await _sibling(ref, resource, forward: true) == null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
