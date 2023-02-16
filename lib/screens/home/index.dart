import 'package:flutter/material.dart';
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
    return MyScaffold(
      isHome: true,
      title: const Text('Islami Jindegi'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
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
                      children: [
                        HijriDate(),
                        const GregorianDate(),
                      ],
                    ),
                  ),
                  const CurrentPrayers(),
                ],
              ),
            ),
            GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: const [
                Resource(
                  route: 'quran',
                  title: 'Quran',
                  icon: 'quran',
                ),
                Resource(
                  route: 'books',
                  title: 'Books',
                  icon: 'book',
                ),
                Resource(
                  route: 'bayans',
                  title: 'Bayans',
                  icon: 'bayan',
                ),
                Resource(
                  route: 'malfuzat',
                  title: 'Malfuzat',
                  icon: 'malfuzat',
                ),
                Resource(
                  route: 'masail',
                  title: 'Masail',
                  icon: 'masail',
                ),
                Resource(
                  route: 'duas',
                  title: 'Dua & Durud',
                  icon: 'dua',
                ),
                Resource(
                  route: 'articles',
                  title: 'Articles',
                  icon: 'article',
                ),
                Resource(
                  route: 'news',
                  title: 'News',
                  icon: 'news',
                ),
                Resource(
                  route: 'madrasahs',
                  title: 'Madrasah',
                  icon: 'madrasah',
                ),
                Resource(
                  route: 'namaz-times',
                  title: 'Namaz Time',
                  icon: 'namaz-time',
                ),
                Resource(
                  route: 'donation',
                  title: 'Donation',
                  icon: 'donate',
                ),
                Resource(
                  route: 'settings',
                  title: 'Settings',
                  icon: 'settings',
                ),
              ],
            ),
            const News(),
          ],
        ),
      ),
    );
  }
}
