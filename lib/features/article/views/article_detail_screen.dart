import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/lazy_item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/core/navigation/offline_sibling_query.dart';
import 'package:native_app/core/navigation/sibling_ref.dart';
import '../providers/article_providers.dart';
import '../models/article.dart';
import '../providers/article_progress_provider.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key});

  Future<SiblingRef?> _sibling(
    WidgetRef ref,
    ArticleItem current, {
    required bool forward,
  }) async {
    final embedded = forward ? current.next : current.previous;
    if (embedded != null) return embedded;
    if (!current.isOffline) return null;
    if (current.position == null) return null;
    final db = await ref.read(articleOfflineServiceProvider).database;
    return findOfflineSibling(
      db: db,
      table: 'articles',
      position: current.position!,
      id: current.id,
      forward: forward,
      descending: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var articleId = GoRouterState.of(context).pathParameters['id'].toString();
    var articleQuery = ref.watch(singleArticleProvider(articleId));

    return articleQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          final previous = await _sibling(ref, resource, forward: false);
          if (!context.mounted) return;
          if (previous != null) {
            context.go('/articles/${previous.id}');
          } else if (context.canPop()) {
            context.pop();
          } else {
            context.go('/articles');
          }
        }

        Future? nextPage() async {
          final next = await _sibling(ref, resource, forward: true);
          if (!context.mounted || next == null) return;
          context.go('/articles/${next.id}');
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(articleProgressProvider.notifier)
              .opened(resource.id, resource.title);
        });

        return ResizableFont(
          storeKey: 'articleFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async {
                if (context.canPop())
                  context.pop();
                else
                  context.go('/articles');
              },
              showPattern: false,
              title: Text(locales.article),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                // Articles are by far the longest bodies in the app (median
                // ~13k characters, up to ~23k), so the body renders lazily
                // block-by-block instead of all at once — see LazyItemContent.
                child: LazyItemContent(
                  fontSizeRatio: fontSizeRatio,
                  htmlBody: resource.body,
                  header: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: PageTitle(
                        text: resource.title,
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
                    if (resource.authorName != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: PageSubtitle(
                          text: resource.authorName!,
                          fontSizeRatio: fontSizeRatio,
                        ),
                      ),
                    if (resource.documentUrl != null)
                      DownloadItem(
                        filePath: fileTitlePath(
                          resource.title,
                          'articles/${resource.id}',
                        ),
                        fileUrl: resource.documentUrl!,
                      ),
                    const SizedBox(height: 15),
                  ],
                  footer: const [SizedBox(height: 30)],
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
                        subtitle: resource.authorName,
                        body: resource.body,
                        link: 'articles/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'Article',
                        title: resource.title,
                        link: 'articles/${resource.id}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'articleFontRatio',
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
