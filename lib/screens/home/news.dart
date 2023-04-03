import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/theme/colors.dart';

class News extends ConsumerWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.news,
      params: const {'quantity': 5},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ThemeColors.color3,
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            child: Text(
              locales.newsAndUpdates,
              style: textTheme.labelMedium?.copyWith(
                color: ThemeColors.color2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                color: ThemeColors.color4,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: modelQuery.when(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeColors.color5,
                      ),
                    ),
                  );
                },
                error: (error, _) => Text(error.toString()),
                data: (resources) {
                  if (resources.isNotEmpty) {
                    return CarouselSlider.builder(
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                      ),
                      itemCount: resources.length,
                      itemBuilder: (context, index, pageIndex) {
                        return InkWell(
                          onTap: () => QR.to('news/${resources[index].id}'),
                          child: Center(
                            child: Text(
                              resources[index].title,
                              style: textTheme.titleMedium?.copyWith(
                                color: ThemeColors.color2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        locales.noItemFound,
                        style: textTheme.titleMedium?.copyWith(
                          color: ThemeColors.color2,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
