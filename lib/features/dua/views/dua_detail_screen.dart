import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
import 'package:native_app/core/navigation/offline_sibling_query.dart';
import 'package:native_app/core/navigation/sibling_ref.dart';
import '../providers/dua_providers.dart';
import '../models/dua.dart';
import '../providers/dua_progress_provider.dart';
import 'audio_player.dart';

class DuaDetailScreen extends ConsumerWidget {
  const DuaDetailScreen({super.key});

  /// Resolves the adjacent dua. Online, the API embeds `previous`/`next` in
  /// the detail payload; offline, the neighbour is sought in local SQLite over
  /// the downloaded subset.
  Future<SiblingRef?> _sibling(
    WidgetRef ref,
    DuaItem current, {
    required bool forward,
  }) async {
    final embedded = forward ? current.next : current.previous;
    if (embedded != null) return embedded;
    if (!current.isOffline) return null;
    if (current.position == null) return null;
    final db = await ref.read(duaOfflineServiceProvider).database;
    return findOfflineSibling(
        db: db,
        table: 'duas',
        position: current.position!,
        id: current.id,
        forward: forward,
        descending: false);
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
          final previous = await _sibling(ref, resource, forward: false);
          if (!context.mounted) return;
          if (previous != null) {
            context.go('/duas/${previous.id}');
          } else if (context.canPop()) {
            context.pop();
          } else {
            context.go('/duas');
          }
        }

        Future? nextPage() async {
          final next = await _sibling(ref, resource, forward: true);
          if (!context.mounted || next == null) return;
          context.go('/duas/${next.id}');
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(duaProgressProvider.notifier)
              .opened(resource.id, resource.title);
        });

        final filePath = resource.audioUrl != null
            ? fileTitlePath(resource.title, 'duas/${resource.id}')
            : null;

        return ResizableFont(
          storeKey: 'duaFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async {
                if (context.canPop())
                  context.pop();
                else
                  context.go('/duas');
              },
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
