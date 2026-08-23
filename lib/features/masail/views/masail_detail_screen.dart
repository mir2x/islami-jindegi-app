import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
import 'package:native_app/core/navigation/content_scope.dart';
import '../providers/masail_providers.dart';
import '../models/masail.dart';
import '../providers/masail_progress_provider.dart';
import 'masail_display.dart';

class MasailDetailScreen extends ConsumerWidget {
  const MasailDetailScreen({super.key});

  Future<SiblingRef?> _sibling(
    WidgetRef ref,
    MasailItem current, {
    required bool forward,
    required ContentScope scope,
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
        descending: true,
        hasAudio: scope.hasAudio);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    final routerState = GoRouterState.of(context);
    final masailId = routerState.pathParameters['id'].toString();
    final scope =
        ContentScope.fromQuery(routerState.uri.queryParameters['scope']);
    final masailQuery =
        ref.watch(singleMasailProvider((id: masailId, scope: scope)));

    return masailQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          final previous =
              await _sibling(ref, resource, forward: false, scope: scope);
          if (!context.mounted) return;
          context.go(previous == null
              ? scope.applyTo('/masail')
              : scope.applyTo('/masail/${previous.id}'));
        }

        Future? nextPage() async {
          final next =
              await _sibling(ref, resource, forward: true, scope: scope);
          if (!context.mounted || next == null) return;
          context.go(scope.applyTo('/masail/${next.id}'));
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(masailProgressProvider.notifier).opened(
                resource.id,
                resource.title,
                tab: switch (scope) {
                  ContentScope.audio => MasailTab.audio,
                  ContentScope.text => MasailTab.text,
                  ContentScope.all => MasailTab.all,
                },
              );
        });

        return ResizableFont(
          storeKey: 'masailFontRatio',
          builder: (context, fontSizeRatio) {
            final filePath = resource.audioUrl != null
                ? fileTitlePath(resource.title, 'masails/${resource.id}')
                : null;

            return AppScaffold(
              onBackPressed: () async => context.canPop()
                  ? context.pop()
                  : context.go(scope.applyTo('/masail')),
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
                        await _sibling(ref, resource,
                            forward: false, scope: scope) ==
                        null,
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
                        await _sibling(ref, resource,
                            forward: true, scope: scope) ==
                        null,
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
