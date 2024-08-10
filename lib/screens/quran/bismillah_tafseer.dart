import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class BismillahTafseer extends ConsumerWidget {
  const BismillahTafseer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.pages,
      params: const {
        'slug': 'bismillah-tafseer',
        'quantity': 1,
        'offline': true,
      },
    );

    var modelQuery = ref.watch(firstModelProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: SizedBox.shrink(),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (item) {
        String arabicBismillah = 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ';

        return ResizableFont(
          storeKey: 'tafseerFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              showPattern: false,
              title: Text(locales.tafseer),
              body: ItemContent(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ValueListenableBuilder<double>(
                      valueListenable: fontSizeRatio,
                      builder: (context, ratio, child) {
                        return SelectableText(
                          arabicBismillah,
                          textDirection: TextDirection.rtl,
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 27 * ratio,
                            height: 1.6,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: PageHtmlBody(
                      text: item.body,
                      fontSizeRatio: fontSizeRatio,
                    ),
                  ),
                ],
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  SocialShare(
                    title: arabicBismillah,
                    body: item.body,
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'tafseerFontRatio',
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
