import 'package:flutter/material.dart';
import 'package:native_app/features/quran_catalogue/views/quran_catalogue_screen.dart';
import 'package:native_app/features/sura/views/sura_page.dart';
import 'package:native_app/features/sura/views/widgets/search_page.dart';
import 'package:native_app/features/sura/views/widgets/tilawat_page.dart';
import 'package:native_app/features/sura_list/views/sura_list_page.dart';
import 'package:native_app/features/quran/views/quran_viewer_screen.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'dart:io';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../features/home/views/home_screen.dart';

import '../features/book/views/book_list_screen.dart';
import '../features/book/views/book_detail_screen.dart';
import '../features/book/views/chapter_screen.dart' as book_feat;
import '../features/book/views/subchapter_screen.dart' as book_feat;
import '../features/book/views/downloads_screen.dart' as book_feat;
import '../features/book/views/downloaded_book_screen.dart' as book_feat;

import '../features/bayan/views/bayan_list_screen.dart' as bayan_feat;
import '../features/bayan/views/bayan_detail_screen.dart' as bayan_feat;
import '../features/bayan/views/bayan_downloads_screen.dart' as bayan_feat;
import '../features/bayan/views/downloaded_bayan_screen.dart' as bayan_feat;

import '../features/malfuzat/views/malfuzat_list_screen.dart';
import '../features/malfuzat/views/malfuzat_detail_screen.dart';
import '../features/malfuzat/views/malfuzat_downloads_screen.dart';
import '../features/malfuzat/views/downloaded_malfuzat_screen.dart';

import '../features/masail/views/masail_list_screen.dart';
import '../features/masail/views/masail_detail_screen.dart';
import '../features/masail/views/ask_question_screen.dart';
import '../features/masail/views/masail_downloads_screen.dart';
import '../features/masail/views/downloaded_masail_screen.dart';

import '../features/dua/views/dua_list_screen.dart';
import '../features/dua/views/dua_detail_screen.dart';

import '../features/article/views/article_list_screen.dart';
import '../features/article/views/article_detail_screen.dart';

import '../features/news/views/news_list_screen.dart';
import '../features/news/views/news_detail_screen.dart';

import '../features/madrasah/views/madrasah_list_screen.dart';
import '../features/madrasah/views/madrasah_detail_screen.dart';
import '../features/madrasah/views/madrasah_introduction_screen.dart';
import '../features/madrasah/views/madrasah_gallery_screen.dart';
import '../features/madrasah/views/madrasah_info_screen.dart';

import '../features/namaz_time/views/namaz_times_screen.dart';
import '../features/namaz_time/views/namaz_time_detail_screen.dart';
import '../features/namaz_time/views/namaz_settings_screen.dart';

import '../features/location/views/location_screen.dart';
import '../features/settings/views/settings_screen.dart';
import '../features/bookmarks/views/bookmarks_screen.dart';
import '../features/page/views/donation_screen.dart';
import '../features/qiblah/views/qiblah_screen.dart';
import '../features/mosques/views/mosques_screen.dart';
import '../features/page/views/about_screen.dart';
import '../features/page/views/contact_us_screen.dart';
import '../features/page/views/important_matters_screen.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class AppRoutes {
  final routes = [
    QRoute(path: '/', name: 'root', builder: () => const Home()),
    QRoute(
      path: '/qurans',
      builder: () => const QuranCatalogueScreen(),
      middleware: [
        QMiddlewareBuilder(
          onEnterFunc: () => WakelockPlus.enable(),
          onExitFunc: () => WakelockPlus.disable(),
        ),
      ],
      children: [
        QRoute(
          path: '/quran',
          middleware: [
            QMiddlewareBuilder(
              onExitFunc: () async {
                // Reset to portrait when leaving quran viewer
                await OrientationToggle.setPortrait();
              },
            ),
          ],
          builder: () {
            final path = QR.params['path'].toString();
            final width = int.parse(QR.params['width'].toString());
            final height = int.parse(QR.params['height'].toString());
            final ext = QR.params['ext'].toString();
            return QuranViewerScreen(
              editionDir: Directory(path),
              imageWidth: width,
              imageHeight: height,
              imageExt: ext,
            );
          },
        ),
        QRoute(
          path: '/sura-list',
          builder: () => const SuraListPage(),
        ),
        QRoute(
          path: '/sura/:id',
          builder: () {
            final id = int.parse(QR.params['id'].toString());
            final scroll = QR.params['scroll'];
            final initialScrollIndex =
                scroll != null ? int.parse(scroll.toString()) : null;
            return SurahPage(
              suraNumber: id,
              initialScrollIndex: initialScrollIndex,
            );
          },
        ),
        QRoute(
          path: '/search',
          builder: () => const SearchPage(),
        ),
        QRoute(
          path: '/tilawat',
          builder: () {
            final sura = int.parse(QR.params['sura'].toString());
            final ayah = int.parse(QR.params['ayah'].toString());
            return TilawatPage(
              initialSuraNumber: sura,
              initialAyahNumber: ayah,
            );
          },
        ),
      ],
    ),
    QRoute(
      path: '/books',
      builder: () => const BookListScreen(),
      children: [
        QRoute(
          path: '/:id',
          builder: () => PageStorage(
            bucket: _bucket,
            child: const BookDetailScreen(),
          ),
          children: [
            QRoute(
              path: '/chapters/:chapter_id',
              builder: () => const book_feat.ChapterScreen(),
            ),
            QRoute(
              path: '/subchapters/:subchapter_id',
              builder: () => const book_feat.SubchapterScreen(),
            ),
          ],
        ),
        QRoute(
          path: '/downloads',
          builder: () => const book_feat.DownloadsScreen(),
          children: [
            QRoute(
              path: '/:id',
              builder: () => const book_feat.DownloadedBookScreen(),
            ),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/bayans',
      builder: () => const bayan_feat.BayanListScreen(),
      children: [
        QRoute(
          path: '/:id',
          builder: () => const bayan_feat.BayanDetailScreen(),
          middleware: [
            QMiddlewareBuilder(
              onEnterFunc: () => WakelockPlus.enable(),
              onExitFunc: () => WakelockPlus.disable(),
            ),
          ],
        ),
        QRoute(
          path: '/downloads',
          builder: () => const bayan_feat.BayanDownloadsScreen(),
          children: [
            QRoute(
                path: '/:id',
                builder: () => const bayan_feat.DownloadedBayanScreen()),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/malfuzat',
      builder: () => const MalfuzatListScreen(),
      children: [
        QRoute(path: '/:id', builder: () => const MalfuzatDetailScreen()),
        QRoute(
          path: '/downloads',
          builder: () => const MalfuzatDownloadsScreen(),
          children: [
            QRoute(
                path: '/:id', builder: () => const DownloadedMalfuzatScreen()),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/masail',
      builder: () => const MasailListScreen(),
      children: [
        QRoute(path: '/:id', builder: () => const MasailDetailScreen()),
        QRoute(path: '/ask-question', builder: () => const AskQuestionScreen()),
        QRoute(
          path: '/downloads',
          builder: () => const MasailDownloadsScreen(),
          children: [
            QRoute(path: '/:id', builder: () => const DownloadedMasailScreen()),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/duas',
      builder: () => const DuaListScreen(),
      children: [
        QRoute(path: '/:id', builder: () => const DuaDetailScreen()),
      ],
    ),
    QRoute(
      path: '/articles',
      builder: () => const ArticleListScreen(),
      children: [
        QRoute(path: '/:id', builder: () => const ArticleDetailScreen()),
      ],
    ),
    QRoute(
      path: '/news',
      builder: () => const NewsListScreen(),
      children: [
        QRoute(path: '/:id', builder: () => const NewsDetailScreen()),
      ],
    ),
    QRoute(
      path: '/madrasahs',
      builder: () => const MadrasahListScreen(),
      children: [
        QRoute(
          path: '/:id',
          builder: () => const MadrasahDetailScreen(),
          children: [
            QRoute(
              path: '/introduction',
              builder: () => const MadrasahIntroductionScreen(),
            ),
            QRoute(
              path: '/gallery',
              builder: () => const MadrasahGalleryScreen(),
            ),
            QRoute(
              path: '/infos/:info_id',
              builder: () => const MadrasahInfoScreen(),
            ),
          ],
        ),
      ],
    ),
    QRoute(
      path: '/namaz-times',
      builder: () => const NamazTimes(),
      children: [
        QRoute(path: '/:slug', builder: () => const NamazTimeDetailScreen()),
        QRoute(path: '/settings', builder: () => const NamazSettings()),
      ],
    ),
    QRoute(path: '/location', builder: () => const LocationScreen()),
    QRoute(path: '/settings', builder: () => const Settings()),
    QRoute(path: '/bookmarks', builder: () => const Bookmarks()),
    QRoute(path: '/donation', builder: () => const DonationScreen()),
    QRoute(path: '/qiblah', builder: () => const Qiblah()),
    QRoute(path: '/mosques', builder: () => const Mosques()),
    QRoute(path: '/about', builder: () => const AboutScreen()),
    QRoute(path: '/contact-us', builder: () => const ContactUsScreen()),
    QRoute(
        path: '/important-matters',
        builder: () => const ImportantMattersScreen()),
    QRoute(
        path: '/important-matters',
        builder: () => const ImportantMattersScreen()),
  ];
}
