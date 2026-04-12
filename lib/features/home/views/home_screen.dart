import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:upgrader/upgrader.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'dates_prayers.dart';
import 'resource.dart';
import 'malfuzat_popup.dart';
import 'news.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    double sideMargin = screenWidth < 340 ? 12 : (isMobile ? 16 : 40);

    return WithPreferences(
      builder: (context, preferences) {
        final appColors = Theme.of(context).extension<AppThemeColors>()!;
        final useDarkHomeLogo =
            ThemeData.estimateBrightnessForColor(appColors.appBarBg) ==
                Brightness.light;

        // Use scaffoldBg (darkest) for hero on dark theme so surfaceBg
        // creates visible contrast. On light theme use primary (dark green).
        // On classic appBarBg is already dark teal, keep it.
        final Color homeHeroBg;
        final Color homeContentBg;
        final heroBrightness =
            ThemeData.estimateBrightnessForColor(appColors.appBarBg);
        final surfaceBrightness =
            ThemeData.estimateBrightnessForColor(appColors.surfaceBg);
        if (heroBrightness == Brightness.dark &&
            surfaceBrightness == Brightness.dark) {
          // Dark theme: both are dark — use scaffoldBg for hero, cardBg for content
          homeHeroBg = appColors.scaffoldBg;
          homeContentBg = appColors.cardBg;
        } else if (heroBrightness == Brightness.light) {
          // Light theme: appBarBg is cream — use primary green for hero
          homeHeroBg = appColors.primary;
          homeContentBg = appColors.surfaceBg;
        } else {
          // Classic: appBarBg is dark teal, surfaceBg is light teal — perfect
          homeHeroBg = appColors.appBarBg;
          homeContentBg = appColors.surfaceBg;
        }

        final needsLightHeroText =
            ThemeData.estimateBrightnessForColor(homeHeroBg) ==
                    Brightness.dark &&
                ThemeData.estimateBrightnessForColor(appColors.appBarText) ==
                    Brightness.dark;
        final heroAppColors = needsLightHeroText
            ? appColors.copyWith(appBarText: const Color(0xEBFFFFFF))
            : appColors;

        return AppScaffold(
          isHome: true,
          title: useDarkHomeLogo
              ? SvgPicture.asset(
                  'assets/images/logos/brand-name-dark.svg',
                  fit: BoxFit.scaleDown,
                  width: 150,
                  height: 25,
                )
              : SvgPicture.asset(
                  'assets/images/logos/brand-name-light.svg',
                  fit: BoxFit.scaleDown,
                  width: 150,
                  height: 25,
                ),
          body: UpgradeAlert(
            child: Column(
              children: [
                // ── Hero ──────────────────────────────────────
                Container(
                  color: homeHeroBg,
                  padding: EdgeInsets.fromLTRB(
                    sideMargin * 2,
                    12,
                    sideMargin * 2,
                    44, // green breathing room below prayer card
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      extensions: <ThemeExtension<dynamic>>[heroAppColors],
                    ),
                    child: const DatesPrayers(),
                  ),
                ),
                // ── Content overlaps hero by 28px ─────────────
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -28,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: homeContentBg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 28),
                        // Grid fills all remaining space
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: sideMargin,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                const rows = 4;
                                const spacing = 10.0;
                                final itemHeight =
                                    (constraints.maxHeight - (rows - 1) * spacing) / rows;
                                final itemWidth =
                                    (constraints.maxWidth - 2 * spacing) / 3;
                                final ratio = (itemHeight > 0 && itemWidth > 0)
                                    ? itemWidth / itemHeight
                                    : 1.0;
                                return GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing,
                              childAspectRatio: ratio,
                              shrinkWrap: false,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Resource(
                                  route: 'qurans',
                                  title: locales.quran,
                                  icon: 'quran',
                                ),
                                Resource(
                                  route: 'books',
                                  title: locales.books,
                                  icon: 'book',
                                ),
                                Resource(
                                  route: 'bayans',
                                  title: locales.bayans,
                                  icon: 'bayan',
                                ),
                                Resource(
                                  route: 'malfuzat',
                                  title: locales.malfuzat,
                                  icon: 'malfuzat',
                                ),
                                Resource(
                                  route: 'masail',
                                  title: locales.masail,
                                  icon: 'masail',
                                ),
                                Resource(
                                  route: 'duas',
                                  title: locales.duaDurud,
                                  icon: 'dua',
                                ),
                                Resource(
                                  route: 'articles',
                                  title: locales.articles,
                                  icon: 'article',
                                ),
                                Resource(
                                  route: 'news',
                                  title: locales.news,
                                  icon: 'news',
                                ),
                                Resource(
                                  route: 'madrasahs',
                                  title: locales.madrasah,
                                  icon: 'madrasah',
                                ),
                                Resource(
                                  route: 'namaz-times',
                                  title: locales.namazTime,
                                  icon: 'namaz-time',
                                ),
                                Resource(
                                  route: 'donation',
                                  title: locales.donation,
                                  icon: 'donate',
                                ),
                                Resource(
                                  route: 'settings',
                                  title: locales.settings,
                                  icon: 'settings',
                                ),
                              ],
                                );
                              },
                            ),
                          ),
                        ),
                        const MalfuzatPopup(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            sideMargin,
                            8,
                            sideMargin,
                            12,
                          ),
                          child: const News(),
                        ),
                      ],
                    ),
                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
