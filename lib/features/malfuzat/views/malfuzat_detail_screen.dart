import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/downloaded_malfuzat.dart';
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
import '../providers/malfuzat_providers.dart';
import '../models/malfuzat.dart';
import '../providers/malfuzat_progress_provider.dart';
import 'malfuzat_display.dart';

class MalfuzatDetailScreen extends ConsumerWidget {
  const MalfuzatDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final malfuzatId = state.pathParameters['id'].toString();
    final scope = ContentScope.fromQuery(state.uri.queryParameters['scope']);
    final malfuzatQuery =
        ref.watch(singleMalfuzatProvider((id: malfuzatId, scope: scope)));

    return malfuzatQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) => _MalfuzatContent(malfuzat: resource, scope: scope),
    );
  }
}

class _MalfuzatContent extends ConsumerWidget {
  final MalfuzatItem malfuzat;
  final ContentScope scope;

  const _MalfuzatContent({required this.malfuzat, required this.scope});

  Future<SiblingRef?> _sibling(
    WidgetRef ref, {
    required bool forward,
  }) async {
    final embedded = forward ? malfuzat.next : malfuzat.previous;
    if (embedded != null) return embedded;
    if (!malfuzat.isOffline) return null;
    if (malfuzat.position == null) return null;
    final db = await ref.read(malfuzatOfflineServiceProvider).database;
    return findOfflineSibling(
        db: db,
        table: 'malfuzats',
        position: malfuzat.position!,
        id: malfuzat.id,
        forward: forward,
        descending: true,
        hasAudio: scope.hasAudio);
  }

  Future<void> _previousPage(BuildContext context, WidgetRef ref) async {
    SiblingRef? previous;
    try {
      previous = await _sibling(ref, forward: false);
    } catch (_) {
      previous = null;
    }
    if (!context.mounted) return;
    if (previous != null) {
      context.go(scope.applyTo('/malfuzat/${previous.id}'));
    } else {
      context.canPop() ? context.pop() : context.go(scope.applyTo('/malfuzat'));
    }
  }

  Future<void> _nextPage(BuildContext context, WidgetRef ref) async {
    SiblingRef? next;
    try {
      next = await _sibling(ref, forward: true);
    } catch (_) {
      return;
    }
    if (!context.mounted || next == null) return;
    context.go(scope.applyTo('/malfuzat/${next.id}'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(malfuzatProgressProvider.notifier).opened(
            malfuzat.id,
            malfuzat.title,
            tab: switch (scope) {
              ContentScope.audio => MalfuzatTab.audio,
              ContentScope.text => MalfuzatTab.text,
              ContentScope.all => MalfuzatTab.all,
            },
          );
    });

    return ResizableFont(
      storeKey: 'malfuzatFontRatio',
      builder: (context, fontSizeRatio) {
        return AppScaffold(
          onBackPressed: () async => context.canPop()
              ? context.pop()
              : context.go(scope.applyTo('/malfuzat')),
          showPattern: false,
          title: Text(locales.malfuzat),
          body: NextPageSwipe(
            onPrevious: () => _previousPage(context, ref),
            onNext: () => _nextPage(context, ref),
            child: ItemContent(
              children: [
                MalfuzatDisplay(
                  malfuzatId: malfuzat.id,
                  title: malfuzat.title,
                  body: malfuzat.body,
                  excerpt: malfuzat.excerpt,
                  audioUrl: malfuzat.audioUrl,
                  author: malfuzat.authorName,
                  fontSizeRatio: fontSizeRatio,
                  downloadItem: (malfuzat.audioUrl != null)
                      ? DownloadItem(
                          filePath: fileTitlePath(
                            malfuzat.title,
                            'malfuzats/${malfuzat.id}',
                          ),
                          fileUrl: malfuzat.audioUrl!,
                          downloadCallback: () async {
                            await ref.watch(
                              createDownloadedMalfuzatProvider({
                                'malfuzatId': malfuzat.id,
                                'title': malfuzat.title,
                                'body': malfuzat.body,
                                'excerpt': malfuzat.excerpt,
                                'audio': malfuzat.audioUrl,
                                'author': malfuzat.authorName,
                                'publishedAt': malfuzat.publishedAt,
                              }).future,
                            );
                          },
                          deleteCallback: () async {
                            await ref.watch(
                              deleteDownloadedMalfuzatProvider(malfuzat.id)
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
                onPrevious: () => _previousPage(context, ref),
                resolveDisabledKey: malfuzat.id,
                resolveDisabled: () async =>
                    await _sibling(ref, forward: false) == null,
              ),
              Row(
                children: [
                  SocialShare(
                    title: malfuzat.title,
                    subtitle: malfuzat.authorName,
                    body: malfuzat.body,
                    link: 'malfuzat/${malfuzat.id}',
                  ),
                  BookmarkButton(
                    type: 'Malfuzat',
                    title: malfuzat.title,
                    link: 'malfuzat/${malfuzat.id}',
                  ),
                ],
              ),
              FontResizer(
                fontSizeRatio: fontSizeRatio,
                storeKey: 'malfuzatFontRatio',
              ),
              Next(
                onNext: () => _nextPage(context, ref),
                resolveDisabledKey: malfuzat.id,
                resolveDisabled: () async =>
                    await _sibling(ref, forward: true) == null,
              ),
            ],
          ),
        );
      },
    );
  }
}
