import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class NamazTime extends ConsumerWidget {
  const NamazTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var fontSizeRatio = FontSizeRatio();

    var query = AllModelsQuery(
      repository: ref.namazTimes,
      params: {'slug': QR.params['slug'], 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resources) {
        var item = resources[0];

        return MyScaffold(
          title: Text(item.title),
          body: ItemContent(
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
          bottomBar: BottomBar(
            children: [
              FontResizer(fontSizeRatio: fontSizeRatio),
            ],
          ),
        );
      },
    );
  }
}
