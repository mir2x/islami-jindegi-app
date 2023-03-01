import 'package:qlevar_router/qlevar_router.dart';

import '../screens/home/index.dart';

import '../screens/quran/index.dart';
import '../screens/quran/surah.dart';
import '../screens/quran/para.dart';
import '../screens/quran/search.dart';
import '../screens/quran/download.dart';

import '../screens/books/index.dart';
import '../screens/books/book.dart';
import '../screens/books/chapter.dart';
import '../screens/books/subchapter.dart';

import '../screens/bayans/index.dart';
import '../screens/bayans/bayan.dart';

import '../screens/malfuzat/index.dart';
import '../screens/malfuzat/malfuzat_item.dart';

import '../screens/masail/index.dart';
import '../screens/masail/masail_item.dart';

import '../screens/duas/index.dart';
import '../screens/duas/dua.dart';

import '../screens/articles/index.dart';
import '../screens/articles/article.dart';

import '../screens/news/index.dart';
import '../screens/news/news_item.dart';

import '../screens/madrasahs/index.dart';
import '../screens/madrasahs/madrasah.dart';

import '../screens/namaz_times/index.dart';
import '../screens/namaz_times/namaz_time.dart';

import '../screens/settings/index.dart';
import '../screens/donation/index.dart';
import '../screens/qiblah/index.dart';
import '../screens/about/index.dart';
import '../screens/contact_us/index.dart';
import '../screens/important_matters/index.dart';

class AppRoutes {
  final routes = [
    QRoute(path: '/', name: 'root', builder: () => const Home()),
    QRoute(
      path: '/quran',
      builder: () => const Quran(),
      children: [
        QRoute(
          path: 'surah/:id',
          builder: () => const Surah(),
        ),
        QRoute(
          path: 'para/:id',
          builder: () => const Para(),
        ),
        QRoute(
          path: '/search',
          builder: () => const QuranSearch(),
        ),
        QRoute(
          path: '/download',
          builder: () => const QuranDownload(),
        ),
      ],
    ),
    QRoute(
      path: '/books',
      builder: () => const Books(),
      children: [
        QRoute(
          path: '/:id',
          builder: () => const Book(),
          children: [
            QRoute(
              path: 'chapters/:chapter_id',
              builder: () => const Chapter(),
            ),
            QRoute(
              path: 'subchapters/:subchapter_id',
              builder: () => const Subchapter(),
            ),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/bayans',
      builder: () => const Bayans(),
      children: [
        QRoute(path: '/:id', builder: () => const Bayan()),
      ],
    ),
    QRoute(
      path: '/malfuzat',
      builder: () => const Malfuzat(),
      children: [
        QRoute(path: '/:id', builder: () => const MalfuzatItem()),
      ],
    ),
    QRoute(
      path: '/masail',
      builder: () => const Masail(),
      children: [
        QRoute(path: '/:id', builder: () => const MasailItem()),
      ],
    ),
    QRoute(
      path: '/duas',
      builder: () => const Duas(),
      children: [
        QRoute(path: '/:id', builder: () => const Dua()),
      ],
    ),
    QRoute(
      path: '/articles',
      builder: () => const Articles(),
      children: [
        QRoute(path: '/:id', builder: () => const Article()),
      ],
    ),
    QRoute(
      path: '/news',
      builder: () => const News(),
      children: [
        QRoute(path: '/:id', builder: () => const NewsItem()),
      ],
    ),
    QRoute(
      path: '/madrasahs',
      builder: () => const Madrasahs(),
      children: [
        QRoute(path: '/:id', builder: () => const Madrasah()),
      ],
    ),
    QRoute(
      path: '/namaz-times',
      builder: () => const NamazTimes(),
      children: [
        QRoute(path: '/:slug', builder: () => const NamazTime()),
      ],
    ),
    QRoute(path: '/settings', builder: () => const Settings()),
    QRoute(path: '/donation', builder: () => const Donation()),
    QRoute(path: '/qiblah', builder: () => const Qiblah()),
    QRoute(path: '/about', builder: () => const About()),
    QRoute(path: '/contact-us', builder: () => const ContactUs()),
    QRoute(path: '/important-matters', builder: () => const ImportantMatters()),
  ];
}
