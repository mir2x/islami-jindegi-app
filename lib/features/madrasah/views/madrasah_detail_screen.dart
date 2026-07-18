import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/madrasah_providers.dart';
import '../models/madrasah.dart';

class MadrasahDetailScreen extends ConsumerWidget {
  const MadrasahDetailScreen({super.key});

  /// Fetch the previous/next madrasah by walking the cached, order-preserved
  /// id list. The .NET API has no server-side "item at position N" lookup
  /// (unlike the old JSON:API backend's `fetchMadrasahsByPosition`), so —
  /// matching the dua/book modules' pattern — adjacency is resolved from
  /// `madrasahNavigationIdsProvider`'s in-memory ordered list.
  Future<MadrasahItem?> _findAdjacentMadrasah(
    WidgetRef ref,
    MadrasahItem current, {
    required bool next,
  }) async {
    try {
      final orderedIds = await ref.read(madrasahNavigationIdsProvider.future);
      final currentIndex = orderedIds.indexOf(current.id);
      if (currentIndex == -1) return null;

      final targetIndex = next ? currentIndex + 1 : currentIndex - 1;
      if (targetIndex < 0 || targetIndex >= orderedIds.length) return null;

      final targetId = orderedIds[targetIndex];
      final api = ref.read(madrasahApiServiceProvider);
      try {
        return await api.fetchSingleMadrasah(targetId);
      } catch (_) {
        final offline = ref.read(madrasahOfflineServiceProvider);
        return await offline.findMadrasahById(targetId);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var madrasahId = GoRouterState.of(context).pathParameters['id'].toString();
    var madrasahQuery = ref.watch(singleMadrasahProvider(madrasahId));

    return madrasahQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          final previous =
              await _findAdjacentMadrasah(ref, resource, next: false);
          if (previous == null) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/madrasahs');
            }
          } else {
            await context.push('/madrasahs/${previous.id}');
          }
        }

        Future? nextPage() async {
          final next = await _findAdjacentMadrasah(ref, resource, next: true);
          if (next != null) {
            await context.push('/madrasahs/${next.id}');
          }
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastMadrasah(resource.id);
        });

        return AppScaffold(
          onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/madrasahs'); },
          title: Text(locales.madrasah),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: appTheme.highlight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: appTheme.divider),
                  ),
                  child: Text(
                    resource.title,
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () =>
                      context.push('/madrasahs/${resource.id}/introduction'),
                  child: ListItem(
                    item: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locales.introduction,
                          style: textTheme.titleMedium,
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: appTheme.secondaryText,
                        ),
                      ],
                    ),
                  ),
                ),
                ...resource.infos.map((info) {
                  return InkWell(
                    onTap: () => context
                        .push('/madrasahs/${resource.id}/infos/${info.id}'),
                    child: ListItem(
                      item: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              info.label,
                              style: textTheme.titleMedium,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: appTheme.secondaryText,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                InkWell(
                  onTap: () =>
                      context.push('/madrasahs/${resource.id}/gallery'),
                  child: ListItem(
                    item: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locales.gallery,
                          style: textTheme.titleMedium,
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: appTheme.secondaryText,
                        ),
                      ],
                    ),
                  ),
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
                    body: resource.introduction,
                    link: 'madrasahs/${resource.id}',
                  ),
                  BookmarkButton(
                    type: 'Madrasah',
                    title: resource.title,
                    link: 'madrasahs/${resource.id}',
                  ),
                ],
              ),
              Next(onNext: nextPage),
            ],
          ),
        );
      },
    );
  }
}
