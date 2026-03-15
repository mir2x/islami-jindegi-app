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
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 768;

    double sideMargin;

    if (isMobile) {
      sideMargin = screenWidth < 340 ? 12 : 20;
    } else {
      sideMargin = 40;
    }

    return WithPreferences(
      builder: (context, preferences) {
        final appColors = Theme.of(context).extension<AppThemeColors>()!;
        final useDarkHomeLogo =
            ThemeData.estimateBrightnessForColor(appColors.appBarBg) ==
                Brightness.light;

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: appColors.appBarBg,
                      border: Border(
                        bottom: BorderSide(
                          color: appColors.divider.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: sideMargin * 2,
                      right: sideMargin * 2,
                      top: isMobile ? screenHeight * 0.02 : screenHeight * 0.05,
                      bottom:
                          isMobile ? screenHeight * 0.02 : screenHeight * 0.05,
                    ),
                    child: const DatesPrayers(),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(
                      sideMargin,
                      screenHeight * 0.03,
                      sideMargin,
                      screenHeight * 0.02,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 14 : 22,
                      isMobile ? 18 : 26,
                      isMobile ? 14 : 22,
                      isMobile ? 18 : 26,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.surfaceBg.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: appColors.divider.withValues(alpha: 0.45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: appColors.shadow.withValues(alpha: 0.08),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: isMobile ? 0.96 : 1.05,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
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
                    ),
                  ),
                  const MalfuzatPopup(),
                  Container(
                    margin: EdgeInsets.only(
                      left: sideMargin,
                      right: sideMargin,
                      bottom:
                          isMobile ? screenHeight * 0.02 : screenHeight * 0.05,
                    ),
                    child: const News(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
