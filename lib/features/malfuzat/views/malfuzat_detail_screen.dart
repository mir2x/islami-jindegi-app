import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/last_visited.dart';
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
import '../providers/malfuzat_providers.dart';
import '../models/malfuzat.dart';
import 'malfuzat_display.dart';

class MalfuzatDetailScreen extends ConsumerWidget {
  const MalfuzatDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var malfuzatId = GoRouterState.of(context).pathParameters['id'].toString();
    var malfuzatQuery = ref.watch(singleMalfuzatProvider(malfuzatId));

    return malfuzatQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) => _MalfuzatContent(malfuzat: resource),
    );
  }
}

class _MalfuzatContent extends ConsumerWidget {
  final MalfuzatItem malfuzat;

  const _MalfuzatContent({required this.malfuzat});

  /// Fetch the previous/next malfuzat by walking the cached, position-ordered
  /// id list. The .NET API has no server-side "item at position N" lookup
  /// (unlike the old JSON:API backend's `fetchMalfuzatByPosition`), so —
  /// matching the book module's `_findAdjacentBook` pattern — we resolve
  /// adjacency from `malfuzatNavigationIdsProvider`'s in-memory ordered list.
  Future<MalfuzatItem?> _findAdjacentMalfuzat(
    WidgetRef ref, {
    required bool next,
  }) async {
    try {
      final orderedIds = await ref.read(malfuzatNavigationIdsProvider.future);
      final currentIndex = orderedIds.indexOf(malfuzat.id);
      if (currentIndex != -1) {
        final targetIndex = next ? currentIndex + 1 : currentIndex - 1;
        if (targetIndex >= 0 && targetIndex < orderedIds.length) {
          final targetId = orderedIds[targetIndex];
          final api = ref.read(malfuzatApiServiceProvider);
          try {
            return await api.fetchSingleMalfuzat(targetId);
          } catch (_) {
            final offline = ref.read(malfuzatOfflineServiceProvider);
            return await offline.findMalfuzatById(targetId);
          }
        }
        return null;
      }
    } catch (_) {
      // Fall back to offline position-based lookup below if API traversal fails.
    }

    final offline = ref.read(malfuzatOfflineServiceProvider);
    final offlineMalfuzat = await offline.findMalfuzatById(malfuzat.id);
    final position = offlineMalfuzat?.position ?? malfuzat.position;
    if (position == null) return null;

    return next
        ? offline.findNextMalfuzatByPosition(position)
        : offline.findPreviousMalfuzatByPosition(position);
  }

  Future<void> _previousPage(BuildContext context, WidgetRef ref) async {
    try {
      final previous = await _findAdjacentMalfuzat(ref, next: false);
      if (previous == null) {
        context.canPop() ? context.pop() : context.go('/malfuzat');
        return;
      }
      context.go('/malfuzat/${previous.id}');
    } catch (_) {
      context.canPop() ? context.pop() : context.go('/malfuzat');
    }
  }

  Future<void> _nextPage(BuildContext context, WidgetRef ref) async {
    try {
      final next = await _findAdjacentMalfuzat(ref, next: true);
      if (next != null) {
        context.go('/malfuzat/${next.id}');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    ref.watch(malfuzatNavigationIdsProvider);

    Future(() {
      ref.read(lastVisitedProvider.notifier).updateLastMalfuzat(malfuzat.id);
    });

    return ResizableFont(
      storeKey: 'malfuzatFontRatio',
      builder: (context, fontSizeRatio) {
        return AppScaffold(
          onBackPressed: () async =>
              context.canPop() ? context.pop() : context.go('/malfuzat'),
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
              Previous(onPrevious: () => _previousPage(context, ref)),
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
              Next(onNext: () => _nextPage(context, ref)),
            ],
          ),
        );
      },
    );
  }
}
