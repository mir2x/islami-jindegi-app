import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import '../providers/namaz_time_providers.dart';

class NamazTimeDetailScreen extends ConsumerWidget {
  const NamazTimeDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var slug = GoRouterState.of(context).pathParameters['slug'].toString();
    var namazQuery = ref.watch(namazTimeBySlugProvider(slug));

    return namazQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resources) {
        if (resources.isEmpty) {
          return const PlaceholderScaffold(
            body: Center(child: Text('Not found')),
          );
        }

        var item = resources.first;
        final api = ref.read(namazTimeApiServiceProvider);

        String itemTitle = contextualTranslation(
          locale: currentLang,
          enText: item.title,
          bnText: item.titleBn,
        );

        Future? previousPage() async {
          if (item.position == null) return;
          var previousResources = await api.fetchByPosition(
            quantity: 1,
            position: item.position! - 1,
          );

          if (previousResources.isNotEmpty) {
            await context.push('/namaz-times/${previousResources.first.slug}');
          } else {
            await context.push('/namaz-times');
          }
        }

        Future? nextPage() async {
          if (item.position == null) return;
          var nextResources = await api.fetchByPosition(
            quantity: 1,
            position: item.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await context.push('/namaz-times/${nextResources.first.slug}');
          }
        }

        return ResizableFont(
          storeKey: 'namazTimeFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await context.push('/namaz-times'),
              showPattern: false,
              title: Text(itemTitle),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: PageHtmlBody(
                        text: item.masail,
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
                  ],
                ),
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Previous(onPrevious: previousPage),
                  SocialShare(
                    title: itemTitle,
                    body: '${item.masail}${item.fazail ?? ''}',
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: FontResizer(
                      fontSizeRatio: fontSizeRatio,
                      storeKey: 'namazTimeFontRatio',
                    ),
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
