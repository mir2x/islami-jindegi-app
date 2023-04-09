import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* import 'package:flutter_gen/gen_l10n/app_localizations.dart'; */
import 'package:intl/intl.dart';
import 'package:pdfx/pdfx.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class QuranDrawer extends ConsumerWidget {
  const QuranDrawer({
    super.key,
    required this.pdfController,
  });

  final PdfController pdfController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* var locales = AppLocalizations.of(context)!; */
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.surahs,
      params: const {'quantity': 114},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: modelQuery.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (resources) {
          return ListView.builder(
            itemCount: resources.length,
            itemBuilder: (BuildContext context, int index) {
              var item = resources[index];

              String surahTitle = contextualTranslation(
                locale: currentLang,
                enText: item.title,
                bnText: item.titleBn,
              );

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    pdfController.jumpToPage(item.position);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Text(
                        '${numFormatter.format(item.position)}.',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(width: 3),
                      Text(surahTitle, style: textTheme.titleMedium),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
