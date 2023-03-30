import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/widgets/calendar/gregorian_date.dart';
import 'current_prayers.dart';
import 'resource.dart';
import 'news.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var locales = AppLocalizations.of(context)!;

    return MyScaffold(
      isHome: true,
      title: Text(locales.siteFullName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HijriDate(),
                        GregorianDate(),
                      ],
                    ),
                  ),
                  const CurrentPrayers(),
                ],
              ),
            ),
            GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: screenHeight * 0.05,
              ),
              childAspectRatio: 1.65,
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
                bottom: screenHeight * 0.02,
                left: 20,
                right: 20,
              ),
              child: const News(),
            )
          ],
        ),
      ),
    );
  }
}
