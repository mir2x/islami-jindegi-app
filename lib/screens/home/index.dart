import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'resource.dart';
import 'news.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Islami Jindegi'),
      body: Column(
        children: [
          Flexible(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
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
                  route: 'namaz-time',
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
          ),
          const News(),
        ],
      ),
    );
  }
}
