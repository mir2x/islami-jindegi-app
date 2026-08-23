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
import 'package:native_app/core/navigation/offline_sibling_query.dart';
import 'package:native_app/core/navigation/sibling_ref.dart';
import '../providers/madrasah_providers.dart';
import '../models/madrasah.dart';

class MadrasahDetailScreen extends ConsumerWidget {
  const MadrasahDetailScreen({super.key});

  Future<SiblingRef?> _sibling(
    WidgetRef ref,
    MadrasahItem current, {
    required bool forward,
  }) async {
    final embedded = forward ? current.next : current.previous;
    if (embedded != null) return embedded;
    if (!current.isOffline) return null;
    if (current.position == null) return null;
    final db = await ref.read(madrasahOfflineServiceProvider).database;
    return findOfflineSibling(
      db: db,
      table: 'madrasahs',
      position: current.position!,
      id: current.id,
      forward: forward,
      descending: false,
      filterPublished: false,
    );
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
          final previous = await _sibling(ref, resource, forward: false);
          if (!context.mounted) return;
          if (previous != null) {
            context.go('/madrasahs/${previous.id}');
          } else if (context.canPop()) {
            context.pop();
          } else {
            context.go('/madrasahs');
          }
        }

        Future? nextPage() async {
          final next = await _sibling(ref, resource, forward: true);
          if (!context.mounted || next == null) return;
          context.go('/madrasahs/${next.id}');
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastMadrasah(resource.id);
        });

        return AppScaffold(
          onBackPressed: () async {
            if (context.canPop())
              context.pop();
            else
              context.go('/madrasahs');
          },
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
