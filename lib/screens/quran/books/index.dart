import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class QuranBooks extends ConsumerWidget {
  const QuranBooks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: Text(locales.pageBasedQuran),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.quranBookQitabs,
                    params: {
                      ...params,
                      'published': true,
                      'include': 'quran-book',
                    },
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisExtent: 350,
                ),
                itemBuilder: (_, item, __) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => QR.to('quran/books/${item.id}'),
                          child: ResponsiveImage(
                            image: item.image,
                            model: 'book',
                            vwset: const {'xs': 50},
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () => QR.to('books/${item.id}'),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
