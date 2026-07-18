import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/dua_providers.dart';
import '../models/dua.dart';
import 'audio_player.dart';

class DuaDetailScreen extends ConsumerWidget {
  const DuaDetailScreen({super.key});

  /// Fetch the previous/next dua by walking the cached, order-preserved id
  /// list. The .NET API has no server-side "item at position N" lookup
  /// (unlike the old JSON:API backend's `fetchDuasByPosition`), so — matching
  /// the masail module's `_findAdjacentMasail` pattern — adjacency is
  /// resolved from `duaNavigationIdsProvider`'s in-memory ordered list.
  Future<DuaItem?> _findAdjacentDua(
    WidgetRef ref,
    DuaItem current, {
    required bool next,
  }) async {
    try {
      final orderedIds = await ref.read(duaNavigationIdsProvider.future);
      final currentIndex = orderedIds.indexOf(current.id);
      if (currentIndex == -1) return null;

      final targetIndex = next ? currentIndex + 1 : currentIndex - 1;
      if (targetIndex < 0 || targetIndex >= orderedIds.length) return null;

      final targetId = orderedIds[targetIndex];
      final api = ref.read(duaApiServiceProvider);
      try {
        return await api.fetchSingleDua(targetId);
      } catch (_) {
        final offline = ref.read(duaOfflineServiceProvider);
        return await offline.findDuaById(targetId);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var duaId = GoRouterState.of(context).pathParameters['id'].toString();
    var duaQuery = ref.watch(singleDuaProvider(duaId));

    return duaQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          final previous = await _findAdjacentDua(ref, resource, next: false);
          if (previous == null) {
            if (context.canPop()) context.pop(); else context.go('/duas');
          } else {
            context.go('/duas/${previous.id}');
          }
        }

        Future? nextPage() async {
          final next = await _findAdjacentDua(ref, resource, next: true);
          if (next != null) {
            context.go('/duas/${next.id}');
          }
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastDuaDurud(resource.id);
        });

        final filePath = resource.audioUrl != null
            ? fileTitlePath(resource.title, 'duas/${resource.id}')
            : null;

        return ResizableFont(
          storeKey: 'duaFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/duas'); },
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
                        text: resource.body ?? '',
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
                    if (resource.audioUrl != null) ...[
                      DuaAudioPlayer(
                        duaId: resource.id,
                        audioUrl: resource.audioUrl!,
                        title: resource.title,
                      ),
                    ],
                    if (resource.audioUrl != null && filePath != null) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: DownloadItem(
                          filePath: filePath,
                          fileUrl: resource.audioUrl!,
                        ),
                      ),
                    ],
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
                        body: resource.body ?? '',
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
