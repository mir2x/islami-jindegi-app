import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class QuranList extends ConsumerWidget {
  const QuranList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    var query = AllModelsQuery(
      repository: ref.quranBookQitabs,
      params: const {
        'published': true,
        'include': 'quran-book',
      },
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return AppScaffold(
      title: Text(locales.quran),
      body: ItemContent(
        children: [
          InkWell(
            onTap: () => QR.to('quran'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5, bottom: 15),
                  child: Text(
                    '${locales.offline} ${locales.quran}',
                    style: textTheme.labelLarge,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/books/quran.svg',
                  fit: BoxFit.contain,
                  width: isMobile ? 175 : 250,
                  height: isMobile ? 270 : 386,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50, left: 5, bottom: 20),
            child: Text(locales.pageBasedQuran, style: textTheme.labelLarge),
          ),
          modelQuery.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) => Text(error.toString()),
            data: (resources) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 2 : 3,
                  crossAxisSpacing: isMobile ? 15 : 20,
                  mainAxisExtent: isMobile ? 325 : 400,
                ),
                itemCount: resources.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = resources[index];

                  return Container(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => QR.to('qurans/books/${item.id}'),
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: ResponsiveImage(
                              image: item.image,
                              model: 'quranBookQitab',
                              vwset: const {'xs': 50},
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () => QR.to('quran/books/${item.id}'),
                            child: Text(
                              contextualTranslation(
                                locale: currentLang,
                                enText: item.title,
                                bnText: item.titleBn,
                              ),
                              style: textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
