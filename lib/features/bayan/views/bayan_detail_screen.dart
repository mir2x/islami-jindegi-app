import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/core/navigation/offline_sibling_query.dart';
import 'package:native_app/core/navigation/sibling_ref.dart';
import '../providers/bayan_providers.dart';
import '../models/bayan.dart';
import 'bayan_display.dart';

class BayanDetailScreen extends ConsumerWidget {
  const BayanDetailScreen({super.key});

  Future<SiblingRef?> _sibling(
    WidgetRef ref,
    Bayan current, {
    required bool forward,
  }) async {
    final embedded = forward ? current.next : current.previous;
    if (embedded != null) return embedded;
    if (!current.isOffline) return null;
    if (current.position == null) return null;
    final db = await ref.read(bayanOfflineServiceProvider).database;
    return findOfflineSibling(
      db: db,
      table: 'bayans',
      position: current.position!,
      id: current.id,
      forward: forward,
      descending: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var bayanId = GoRouterState.of(context).pathParameters['id'].toString();
    var bayanQuery = ref.watch(singleBayanProvider(bayanId));

    return bayanQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          final previous = await _sibling(ref, resource, forward: false);
          if (!context.mounted) return;
          context.go(
              previous == null ? '/bayans' : '/bayans/${previous.id}');
        }

        Future? nextPage() async {
          final next = await _sibling(ref, resource, forward: true);
          if (!context.mounted || next == null) return;
          context.go('/bayans/${next.id}');
        }

        Future(() {
          ref.read(lastVisitedProvider.notifier).updateLastBayan(resource.id);
        });

        return AppScaffold(
          onBackPressed: () async =>
              context.canPop() ? context.pop() : context.go('/bayans'),
          showPattern: false,
          title: Text(locales.bayan),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                BayanDisplay(
                  bayanId: resource.id,
                  title: resource.title,
                  excerpt: resource.excerpt,
                  location: resource.location,
                  audioUrl: resource.audioUrl,
                  speaker: resource.speakerName,
                  publishedAt: resource.publishedAt,
                  downloadItem: (resource.audioUrl != null)
                      ? DownloadItem(
                          filePath: fileTitlePath(
                            resource.title,
                            'bayans/${resource.id}',
                          ),
                          fileUrl: resource.audioUrl!,
                          downloadCallback: () async {
                            await ref.watch(
                              createDownloadedBayanProvider({
                                'bayanId': resource.id,
                                'title': resource.title,
                                'excerpt': resource.excerpt,
                                'location': resource.location,
                                'audio': resource.audioUrl,
                                'speaker': resource.speakerName,
                                'publishedAt': resource.publishedAt,
                              }).future,
                            );
                          },
                          deleteCallback: () async {
                            await ref.watch(
                              deleteDownloadedBayanProvider(resource.id).future,
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
                    subtitle: resource.speakerName,
                    link: 'bayans/${resource.id}',
                    fileLink: resource.audioUrl,
                  ),
                  BookmarkButton(
                    type: 'Bayan',
                    title: resource.title,
                    link: 'bayans/${resource.id}',
                  ),
                ],
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
  }
}
