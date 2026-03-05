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

class MadrasahInfoScreen extends ConsumerWidget {
  const MadrasahInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var infoId = GoRouterState.of(context).pathParameters['info_id'].toString();
    var infoQuery = ref.watch(singleMadrasahInfoProvider(infoId));

    return infoQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(madrasahApiServiceProvider);
        final madrasahId = resource.madrasahId ?? GoRouterState.of(context).pathParameters['id'].toString();

        Future? previousPage() async {
          if (resource.position != null && resource.position! > 1) {
            var previousResources = await api.fetchInfosByMadrasah(
              madrasahId: madrasahId,
              quantity: 1,
              position: resource.position! - 1,
            );

            if (previousResources.isNotEmpty) {
              await context.push(
                'madrasahs/$madrasahId/infos/${previousResources.first.id}',
              );
            }
          } else {
            await context.push('/madrasahs/$madrasahId/introduction');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchInfosByMadrasah(
            madrasahId: madrasahId,
            quantity: 1,
            position: resource.position! + 1,
          );

          if (nextResources.isNotEmpty) {
            await context.push(
              'madrasahs/$madrasahId/infos/${nextResources.first.id}',
            );
          } else {
            await context.push('/madrasahs/$madrasahId/gallery');
          }
        }

        return ResizableFont(
          storeKey: 'madrasahFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await context.push('/madrasahs/$madrasahId'),
              showPattern: false,
              title: Text(resource.madrasahTitle ?? ''),
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
