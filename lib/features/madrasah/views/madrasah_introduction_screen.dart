import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/madrasah_providers.dart';

/// Note: unlike book/article/malfuzat/masail/dua, a madrasah has no
/// `document` field on the .NET API (confirmed against `Models/Madrasah.cs`
/// and the migration command's `SELECT` list, neither of which carry a
/// document/download concept for this entity), so the old download-item
/// block from the JSON:API version is dropped entirely rather than ported.
class MadrasahIntroductionScreen extends ConsumerWidget {
  const MadrasahIntroductionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var madrasahId = GoRouterState.of(context).pathParameters['id'].toString();

    var madrasahQuery = ref.watch(singleMadrasahProvider(madrasahId));

    return madrasahQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          await context.push('/madrasahs/${resource.id}');
        }

        Future? nextPage() async {
          if (resource.infos.isNotEmpty) {
            await context.push(
              'madrasahs/${resource.id}/infos/${resource.infos.first.id}',
            );
          } else {
            await context.push('/madrasahs/${resource.id}/gallery');
          }
        }

        return ResizableFont(
          storeKey: 'madrasahFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async =>
                  await context.push('/madrasahs/${resource.id}'),
              showPattern: false,
              title: Text(resource.title),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: PageTitle(
                        text: locales.introduction,
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: PageHtmlBody(
                        text: resource.introduction,
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
                    title: resource.title,
                    body: resource.introduction,
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'madrasahFontRatio',
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
