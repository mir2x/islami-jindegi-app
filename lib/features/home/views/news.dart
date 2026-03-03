import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/features/news/providers/news_providers.dart';

class News extends ConsumerWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;
    bool isSmallMobile = screenWidth < 340;

    var colorScheme = Theme.of(context).colorScheme;

    final fontStyle = isSmallMobile
        ? textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
            height: 1.2,
          )
        : textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            height: 1.2,
          );

    final modelQuery = ref.watch(latestNewsProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colorScheme.secondaryContainer,
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 100 : 150,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 10 : 20,
              horizontal: isMobile ? 10 : 30,
            ),
            child: Text(
              locales.newsAndUpdates,
              style: fontStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: WithPreferences(
              builder: (context, preferences) {
                double height;

                if (isMobile) {
                  height = isSmallMobile ? 60 : 75;
                } else {
                  height = 95;
                }

                return Container(
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: modelQuery.when(
                    loading: () {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      );
                    },
                    error: (error, _) {
                      return Center(
                        child: Text(
                          locales.connectToInternetMsg,
                          style: fontStyle,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
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
                                  style: fontStyle,
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
                            locales.connectToInternetMsg,
                            style: fontStyle,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
