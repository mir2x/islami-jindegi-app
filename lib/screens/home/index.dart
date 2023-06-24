import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'dates_prayers.dart';
import 'resource.dart';
import 'news.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 768;

    return AppScaffold(
      isHome: true,
      title: Text(locales.siteFullName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: isMobile ? 20 : 40,
                right: isMobile ? 20 : 40,
                top: isMobile ? screenHeight * 0.02 : screenHeight * 0.05,
              ),
              child: const DatesPrayers(),
            ),
            GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.05,
                horizontal: screenWidth * 0.02,
              ),
              childAspectRatio: isMobile ? 1.6 : 1.75,
              crossAxisSpacing: 5,
              mainAxisSpacing: screenHeight * 0.025,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Resource(
                  route: 'quran',
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
            Container(
              margin: EdgeInsets.only(
                left: isMobile ? 20 : 40,
                right: isMobile ? 20 : 40,
                bottom: isMobile ? screenHeight * 0.02 : screenHeight * 0.05,
              ),
              child: const News(),
            )
          ],
        ),
      ),
    );
  }
}
