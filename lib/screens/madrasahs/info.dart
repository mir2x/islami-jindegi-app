import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
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

class MadrasahInfo extends ConsumerWidget {
  const MadrasahInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.madrasahInfos,
      id: QR.params['info_id'].toString(),
      params: const {'include': 'madrasah'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          if (resource.position > 1) {
            var previousResources = await ref.madrasahInfos.findAll(
                  params: {
                    'madrasahId': resource.madrasah.value.id,
                    'quantity': 1,
                    'position': resource.position - 1,
                  },
                ) ??
                [];

            if (previousResources.isNotEmpty) {
              await QR.to(
                'madrasahs/${resource.madrasah.value.id}/infos/${previousResources.first.id}',
              );
            }
          } else {
            await QR.to(
              'madrasahs/${resource.madrasah.value.id}/introduction',
            );
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.madrasahInfos.findAll(
                params: {
                  'madrasahId': resource.madrasah.value.id,
                  'quantity': 1,
                  'position': resource.position + 1,
                },
              ) ??
              [];

          if (nextResources.isNotEmpty) {
            await QR.to(
              'madrasahs/${resource.madrasah.value.id}/infos/${nextResources.first.id}',
            );
          } else {
            await QR.to(
              'madrasahs/${resource.madrasah.value.id}/gallery',
            );
          }
        }

        String resourceLabel = contextualTranslation(
          locale: currentLang,
          enText: resource.label,
          bnText: resource.labelBn,
        );

        return AppScaffold(
          title: Text(resource.madrasah.value.title),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: PageTitle(
                    text: resourceLabel,
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
                title: resourceLabel,
                body: resource.info,
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
