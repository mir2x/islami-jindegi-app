import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
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
import '../providers/madrasah_providers.dart';

class MadrasahDetailScreen extends ConsumerWidget {
  const MadrasahDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var madrasahId = QR.params['id'].toString();
    var madrasahQuery = ref.watch(singleMadrasahProvider(madrasahId));

    return madrasahQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(madrasahApiServiceProvider);

        Future? previousPage() async {
          if (resource.position == null) {
            await QR.to('madrasahs');
            return;
          }
          var previousResources = await api.fetchMadrasahsByPosition(
            quantity: 1,
            position: resource.position! - 1,
          );

          if (previousResources.isEmpty) {
            await QR.to('madrasahs');
          } else {
            await QR.to('madrasahs/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchMadrasahsByPosition(
            quantity: 1,
            position: resource.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await QR.to('madrasahs/${nextResources.first.id}');
          }
        }

        Future(() {
          ref
              .read(lastVisitedProvider.notifier)
              .updateLastMadrasah(resource.id);
        });

        return AppScaffold(
          onBackPressed: () async => await QR.to('madrasahs'),
          title: Text(locales.madrasah),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Text(resource.title, style: textTheme.labelLarge),
                ),
                InkWell(
                  onTap: () => QR.to('madrasahs/${resource.id}/introduction'),
                  child: ListItem(
                    item: Text(
                      locales.introduction,
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                ...resource.madrasahInfos.map((info) {
                  return InkWell(
                    onTap: () =>
                        QR.to('madrasahs/${resource.id}/infos/${info.id}'),
                    child: ListItem(
                      item: Text(
                        info.label,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  );
                }),
                InkWell(
                  onTap: () => QR.to('madrasahs/${resource.id}/gallery'),
                  child: ListItem(
                    item: Text(
                      locales.gallery,
                      style: textTheme.titleMedium,
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
