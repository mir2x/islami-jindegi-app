import 'package:qlevar_router/qlevar_router.dart';

import '../screens/home/index.dart';
import '../screens/quran/index.dart';
import '../screens/books/index.dart';

import '../screens/bayans/index.dart';
import '../screens/bayans/bayan.dart';

import '../screens/malfuzat/index.dart';
import '../screens/malfuzat/malfuzat_item.dart';

import '../screens/masail/index.dart';
import '../screens/masail/masail_item.dart';

import '../screens/dua/index.dart';

import '../screens/articles/index.dart';
import '../screens/articles/article.dart';

import '../screens/news/index.dart';
import '../screens/news/news_item.dart';

import '../screens/madrasahs/index.dart';
import '../screens/namaz_time/index.dart';
import '../screens/donation/index.dart';
import '../screens/settings/index.dart';

class AppRoutes {
  final routes = [
    QRoute(path: '/', builder: () => const Home()),
    QRoute(path: '/quran', builder: () => const Quran()),
    QRoute(path: '/books', builder: () => const Books()),

    QRoute(
      path: '/bayans',
      builder: () => const Bayans(),
      children: [
        QRoute(path: '/:id', builder: () => const Bayan()),
      ]
    ),

    QRoute(
      path: '/malfuzat',
      builder: () => const Malfuzat(),
      children: [
        QRoute(path: '/:id', builder: () => const MalfuzatItem()),
      ]
    ),

    QRoute(
      path: '/masail',
      builder: () => const Masail(),
      children: [
        QRoute(path: '/:id', builder: () => const MasailItem()),
      ]
    ),

    QRoute(path: '/dua', builder: () => const Dua()),

    QRoute(
      path: '/articles',
      builder: () => const Articles(),
      children: [
        QRoute(path: '/:id', builder: () => const Article()),
      ]
    ),

    QRoute(
      path: '/news',
      builder: () => const News(),
      children: [
        QRoute(path: '/:id', builder: () => const NewsItem()),
      ]
    ),

    QRoute(path: '/madrasahs', builder: () => const Madrasahs()),
    QRoute(path: '/namaz-time', builder: () => const NamazTime()),
    QRoute(path: '/donation', builder: () => const Donation()),
    QRoute(path: '/settings', builder: () => const Settings()),
  ];
}
