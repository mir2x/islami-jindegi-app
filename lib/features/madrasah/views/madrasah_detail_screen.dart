import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class MadrasahDetailScreen extends ConsumerWidget {
  const MadrasahDetailScreen({super.key});

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
        final api = ref.read(madrasahApiServiceProvider);

        Future? previousPage() async {
          if (resource.position == null) {
            await context.push('/madrasahs');
            return;
          }
          var previousResources = await api.fetchMadrasahsByPosition(
            quantity: 1,
            position: resource.position! - 1,
          );

          if (previousResources.isEmpty) {
            await context.push('/madrasahs');
          } else {
            await context.push('/madrasahs/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchMadrasahsByPosition(
            quantity: 1,
            position: resource.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await context.push('/madrasahs/${nextResources.first.id}');
          }
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastMadrasah(resource.id);
        });

        return AppScaffold(
          onBackPressed: () async => await context.push('/madrasahs'),
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
                ...resource.madrasahInfos.map((info) {
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
