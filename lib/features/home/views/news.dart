import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/features/news/providers/news_providers.dart';

class News extends ConsumerWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final modelQuery = ref.watch(latestNewsProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? appColors.highlight.withValues(alpha: 0.85)
            : appColors.cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? appColors.highlightBorder.withValues(alpha: 0.7)
              : appColors.divider.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Text(
            locales.newsAndUpdates,
            style: textTheme.labelSmall?.copyWith(
              color: appColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 28,
            color: appColors.divider.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: modelQuery.when(
              loading: () => SizedBox(
                height: 20,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(appColors.active),
                    ),
                  ),
                ),
              ),
              error: (_, __) => Text(
                locales.connectToInternetMsg,
                style: textTheme.labelSmall?.copyWith(
                  color: appColors.secondaryText,
                ),
                maxLines: 2,
              ),
              data: (resources) {
                if (resources.isEmpty) {
                  return Text(
                    locales.connectToInternetMsg,
                    style: textTheme.labelSmall?.copyWith(
                      color: appColors.secondaryText,
                    ),
                    maxLines: 2,
                  );
                }
                return CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1.0,
                    height: 36,
                  ),
                  itemCount: resources.length,
                  itemBuilder: (context, index, _) {
                    return InkWell(
                      onTap: () => context.push('/news/${resources[index].id}'),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          resources[index].title,
                          style: textTheme.labelSmall?.copyWith(
                            color: appColors.primaryText,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
