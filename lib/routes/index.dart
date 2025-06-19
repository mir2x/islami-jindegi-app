import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../screens/home/index.dart';

import '../screens/quran/quran_list.dart';
import '../screens/quran/digital/quran.dart';
import '../screens/quran/digital/surah.dart';
import '../screens/quran/digital/surah_description.dart';
import '../screens/quran/digital/para.dart';
import '../screens/quran/book/quran.dart';
import '../screens/quran/tafseer/ayah.dart';
import '../screens/quran/tafseer/bismillah.dart';
import '../screens/quran/bookmarks.dart';
import '../screens/quran/search.dart';

import '../screens/books/index.dart';
import '../screens/books/book.dart';
import '../screens/books/chapter.dart';
import '../screens/books/subchapter.dart';
import '../screens/books/downloads.dart';
import '../screens/books/downloaded_book.dart';

import '../screens/bayans/index.dart';
import '../screens/bayans/bayan.dart';
import '../screens/bayans/downloads.dart';
import '../screens/bayans/downloaded_bayan.dart';

import '../screens/malfuzat/index.dart';
import '../screens/malfuzat/malfuzat_item.dart';
import '../screens/malfuzat/downloads.dart';
import '../screens/malfuzat/downloaded_malfuzat.dart';

import '../screens/masail/index.dart';
import '../screens/masail/masail_item.dart';
import '../screens/masail/ask_question.dart';
import '../screens/masail/downloads.dart';
import '../screens/masail/downloaded_masail.dart';

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
import '../screens/mosques/index.dart';
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
        QRoute(
          path: '/books/:id',
          builder: () => const PdfQuran(),
          middleware: [
            QMiddlewareBuilder(
              onEnterFunc: () => WakelockPlus.enable(),
              onExitFunc: () => WakelockPlus.disable(),
            ),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/quran',
      builder: () => const DigitalQuran(),
      children: [
        QRoute(
          path: '/surah/:slug',
          builder: () => PageStorage(
            bucket: _bucket,
            child: const Surah(),
          ),
          middleware: [
            QMiddlewareBuilder(
              onEnterFunc: () => WakelockPlus.enable(),
              onExitFunc: () => WakelockPlus.disable(),
            ),
          ],
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
          middleware: [
            QMiddlewareBuilder(
              onEnterFunc: () => WakelockPlus.enable(),
              onExitFunc: () => WakelockPlus.disable(),
            ),
          ],
        ),
        QRoute(
          path: '/tafseers/:ayah_id',
          builder: () => const AyahTafseer(),
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
          builder: () => PageStorage(
            bucket: _bucket,
            child: const BookItem(),
          ),
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
        QRoute(
          path: '/downloads',
          builder: () => const BookDownloads(),
          children: [
            QRoute(path: '/:id', builder: () => const DownloadedBook()),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/bayans',
      builder: () => const Bayans(),
      children: [
        QRoute(
          path: '/:id',
          builder: () => const Bayan(),
          middleware: [
            QMiddlewareBuilder(
              onEnterFunc: () => WakelockPlus.enable(),
              onExitFunc: () => WakelockPlus.disable(),
            ),
          ],
        ),
        QRoute(
          path: '/downloads',
          builder: () => const BayanDownloads(),
          children: [
            QRoute(path: '/:id', builder: () => const DownloadedBayan()),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/malfuzat',
      builder: () => const Malfuzat(),
      children: [
        QRoute(path: '/:id', builder: () => const MalfuzatItem()),
        QRoute(
          path: '/downloads',
          builder: () => const MalfuzatDownloads(),
          children: [
            QRoute(path: '/:id', builder: () => const DownloadedMalfuzat()),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/masail',
      builder: () => const Masail(),
      children: [
        QRoute(path: '/:id', builder: () => const MasailItem()),
        QRoute(path: '/ask-question', builder: () => const AskQuestion()),
        QRoute(
          path: '/downloads',
          builder: () => const MasailDownloads(),
          children: [
            QRoute(path: '/:id', builder: () => const DownloadedMasail()),
          ],
        ),
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
    QRoute(path: '/mosques', builder: () => const Mosques()),
    QRoute(path: '/about', builder: () => const About()),
    QRoute(path: '/contact-us', builder: () => const ContactUs()),
    QRoute(path: '/important-matters', builder: () => const ImportantMatters()),
  ];
}
