import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:native_app/theme/app_theme_color.dart';
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

    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    final fontStyle = isSmallMobile
        ? textTheme.labelSmall?.copyWith(
            color: appColors.primaryText,
            height: 1.2,
          )
        : textTheme.labelMedium?.copyWith(
            color: appColors.primaryText,
            height: 1.2,
          );

    final modelQuery = ref.watch(latestNewsProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: appColors.cardBg.withValues(alpha: 0.9),
        border: Border.all(
          color: appColors.divider.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 100 : 150,
            margin: const EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 10 : 20,
              horizontal: isMobile ? 10 : 30,
            ),
            decoration: BoxDecoration(
              color: appColors.highlight.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              locales.newsAndUpdates,
              style: fontStyle?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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
                  margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: appColors.divider,
                      width: 1,
                    ),
                    color: appColors.cardBg,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: modelQuery.when(
                    loading: () {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            appColors.active,
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
                              onTap: () =>
                                  context.push('/news/${resources[index].id}'),
                              child: Center(
                                child: Text(
                                  resources[index].title,
                                  style: fontStyle?.copyWith(height: 1.3),
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
