import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/helpers/file_utils.dart';

class MadrasahIntroduction extends ConsumerWidget {
  const MadrasahIntroduction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.madrasahs,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          await QR.to('madrasahs/${resource.id}');
        }

        Future? nextPage() async {
          var nextResources = await ref.madrasahInfos.findAll(
            params: {
              'madrasahId': resource.id,
              'quantity': 1,
              'position': 1,
            },
          );

          if (nextResources.isNotEmpty) {
            await QR.to(
              'madrasahs/${resource.id}/infos/${nextResources.first.id}',
            );
          } else {
            await QR.to('madrasahs/${resource.id}/gallery');
          }
        }

        return AppScaffold(
          onBackPressed: () async => await QR.to('madrasahs/${resource.id}'),
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
                if (resource.document != null) ...[
                  DownloadItem(
                    filePath: resource.document['id'],
                    fileUrl: fileSrcUrl(resource.document),
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
                title: resource.title,
                body: resource.introduction,
              ),
              FontResizer(fontSizeRatio: fontSizeRatio),
              Next(onNext: nextPage),
            ],
          ),
        );
      },
    );
  }
}
