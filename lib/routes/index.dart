import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../screens/home/index.dart';

import '../screens/quran/quran_list.dart';
import '../screens/quran/index.dart';
import '../screens/quran/surah.dart';
import '../screens/quran/surah_description.dart';
import '../screens/quran/para.dart';
import '../screens/quran/tafseer.dart';
import '../screens/quran/bismillah_tafseer.dart';
import '../screens/quran/bookmarks.dart';
import '../screens/quran/search.dart';
import '../screens/quran/book/book.dart';

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
import '../screens/masail/ask_question.dart';

import '../screens/duas/index.dart';
import '../screens/duas/dua.dart';

import '../screens/articles/index.dart';
import '../screens/articles/article.dart';

import '../screens/news/index.dart';
import '../screens/news/news_item.dart';

import '../screens/madrasahs/index.dart';
import '../screens/madrasahs/madrasah.dart';
import '../screens/madrasahs/introduction.dart';
import '../screens/madrasahs/gallery.dart';
import '../screens/madrasahs/info.dart';

import '../screens/namaz_times/index.dart';
import '../screens/namaz_times/namaz_time.dart';
import '../screens/namaz_times/settings.dart';

import '../screens/location/index.dart';
import '../screens/settings/index.dart';
import '../screens/bookmarks/index.dart';
import '../screens/donation/index.dart';
import '../screens/qiblah/index.dart';
import '../screens/about/index.dart';
import '../screens/contact_us/index.dart';
import '../screens/important_matters/index.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class AppRoutes {
  final routes = [
    QRoute(path: '/', name: 'root', builder: () => const Home()),
    QRoute(
      path: '/qurans',
      builder: () => const QuranList(),
      children: [
        QRoute(path: '/books/:id', builder: () => const QuranBook()),
      ],
    ),
    QRoute(
      path: '/quran',
      builder: () => PageStorage(
        bucket: _bucket,
        child: const Quran(),
      ),
      children: [
        QRoute(
          path: '/surah/:slug',
          builder: () => PageStorage(
            bucket: _bucket,
            child: const Surah(),
          ),
          children: [
            QRoute(
              path: '/description',
              builder: () => const SurahDescription(),
            ),
          ],
        ),
        QRoute(
          path: '/para/:slug',
          builder: () => PageStorage(
            bucket: _bucket,
            child: const Para(),
          ),
        ),
        QRoute(
          path: '/tafseers/:ayah_id',
          builder: () => const Tafseer(),
        ),
        QRoute(
          path: '/bismillah-tafseer',
          builder: () => const BismillahTafseer(),
        ),
        QRoute(
          path: '/bookmarks',
          builder: () => const QuranBookmarks(),
        ),
        QRoute(
          path: '/search',
          builder: () => const QuranSearch(),
        ),
      ],
    ),
    QRoute(
      path: '/books',
      builder: () => const Books(),
      children: [
        QRoute(
          path: '/:id',
          builder: () => const BookItem(),
          children: [
            QRoute(
              path: '/chapters/:chapter_id',
              builder: () => const Chapter(),
            ),
            QRoute(
              path: '/subchapters/:subchapter_id',
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
        QRoute(path: '/ask-question', builder: () => const AskQuestion()),
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
        QRoute(
          path: '/:id',
          builder: () => const Madrasah(),
          children: [
            QRoute(
              path: '/introduction',
              builder: () => const MadrasahIntroduction(),
            ),
            QRoute(
              path: '/gallery',
              builder: () => const MadrasahGallery(),
            ),
            QRoute(
              path: '/infos/:info_id',
              builder: () => const MadrasahInfo(),
            ),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/namaz-times',
      builder: () => const NamazTimes(),
      children: [
        QRoute(path: '/:slug', builder: () => const NamazTime()),
        QRoute(path: '/settings', builder: () => const NamazSettings()),
      ],
    ),
    QRoute(path: '/location', builder: () => const Location()),
    QRoute(path: '/settings', builder: () => const Settings()),
    QRoute(path: '/bookmarks', builder: () => const Bookmarks()),
    QRoute(path: '/donation', builder: () => const Donation()),
    QRoute(path: '/qiblah', builder: () => const Qiblah()),
    QRoute(path: '/about', builder: () => const About()),
    QRoute(path: '/contact-us', builder: () => const ContactUs()),
    QRoute(path: '/important-matters', builder: () => const ImportantMatters()),
  ];
}
