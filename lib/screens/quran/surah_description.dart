import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class SurahDescription extends ConsumerWidget {
  const SurahDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;

    var query = AllModelsQuery(
      repository: ref.surahs,
      params: {'slug': QR.params['slug'].toString(), 'quantity': 1},
    );

    var modelQuery = ref.watch(firstModelProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: SizedBox.shrink(),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (surah) {
        return ResizableFont(
          storeKey: 'tafseerFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              showPattern: false,
              title: Text(
                contextualTranslation(
                  locale: currentLang,
                  enText: surah.title,
                  bnText: surah.titleBn,
                ),
              ),
              body: ItemContent(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: PageHtmlBody(
                      text: surah.introduction,
                      fontSizeRatio: fontSizeRatio,
                    ),
                  ),
                ],
              ),
              bottomBar: BottomBar(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: FontResizer(
                      fontSizeRatio: fontSizeRatio,
                      storeKey: 'tafseerFontRatio',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
