import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// A madrasah's individual info entries (label/value pairs) are nested
/// directly inside `MadrasahDetail.infos` on the .NET API — there's no
/// standalone `/madrasah_infos/:id` endpoint to fetch one by id (unlike the
/// old JSON:API backend's `fetchSingleInfo`/`fetchInfosByMadrasah`), so this
/// screen just loads the parent madrasah via `singleMadrasahProvider` (the
/// same provider the detail/introduction/gallery screens use — Riverpod
/// dedupes the in-flight/cached fetch) and looks up the requested info, and
/// its previous/next neighbours, by index within that embedded list.
class MadrasahInfoScreen extends ConsumerWidget {
  const MadrasahInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var madrasahId = GoRouterState.of(context).pathParameters['id'].toString();
    var infoId =
        GoRouterState.of(context).pathParameters['info_id'].toString();
    var madrasahQuery = ref.watch(singleMadrasahProvider(madrasahId));

    return madrasahQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (madrasah) {
        final index = madrasah.infos.indexWhere((i) => i.id == infoId);
        if (index == -1) {
          return const ModelExeptionHandler(error: 'Info not found');
        }
        final resource = madrasah.infos[index];

        Future? previousPage() async {
          if (index > 0) {
            await context.push(
              'madrasahs/$madrasahId/infos/${madrasah.infos[index - 1].id}',
            );
          } else {
            await context.push('/madrasahs/$madrasahId/introduction');
          }
        }

        Future? nextPage() async {
          if (index < madrasah.infos.length - 1) {
            await context.push(
              'madrasahs/$madrasahId/infos/${madrasah.infos[index + 1].id}',
            );
          } else {
            await context.push('/madrasahs/$madrasahId/gallery');
          }
        }

        return ResizableFont(
          storeKey: 'madrasahFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/madrasahs/$madrasahId'); },
              showPattern: false,
              title: Text(madrasah.title),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: PageTitle(
                        text: resource.label,
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: PageHtmlBody(
                        text: resource.info,
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
                    title: resource.label,
                    body: resource.info,
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
