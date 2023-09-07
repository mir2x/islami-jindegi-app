import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class NamazTime extends ConsumerWidget {
  const NamazTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var fontSizeRatio = FontSizeRatio();

    var query = AllModelsQuery(
      repository: ref.namazTimes,
      params: {'slug': QR.params['slug'], 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resources) {
        var item = resources.first;

        String itemTitle = contextualTranslation(
          locale: currentLang,
          enText: item.title,
          bnText: item.titleBn,
        );

        Future? previousPage() async {
          var previousResources = await ref.namazTimes.findAll(
            params: {
              'quantity': 1,
              'position': item.position - 1,
            },
          );

          if (previousResources.isNotEmpty) {
            await QR.to('namaz-times/${previousResources.first.slug}');
          } else {
            await QR.to('namaz-times');
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.namazTimes.findAll(
            params: {
              'quantity': 1,
              'position': item.position + 1,
            },
          );

          if (nextResources.isNotEmpty) {
            await QR.to('namaz-times/${nextResources.first.slug}');
          }
        }

        return AppScaffold(
          onBackPressed: () async => await QR.to('namaz-times'),
          title: Text(itemTitle),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: PageTitle(
                    text: locales.masail,
                    fontSizeRatio: fontSizeRatio,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: PageHtmlBody(
                    text: item.masail,
                    fontSizeRatio: fontSizeRatio,
                  ),
                ),
                if (item.fazail != null) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 15),
                    child: PageTitle(
                      text: locales.fazail,
                      fontSizeRatio: fontSizeRatio,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: PageHtmlBody(
                      text: item.fazail,
                      fontSizeRatio: fontSizeRatio,
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
              SocialShare(
                title: itemTitle,
                body: '${item.masail}${item.fazail}',
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: FontResizer(fontSizeRatio: fontSizeRatio),
              ),
              Next(onNext: nextPage),
            ],
          ),
        );
      },
    );
  }
}
