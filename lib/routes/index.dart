import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/quran/views/quran_viewer_screen.dart';
import 'package:native_app/features/quran_catalogue/views/quran_catalogue_screen.dart';
import 'package:native_app/features/sura/views/sura_page.dart';
import 'package:native_app/features/sura/views/widgets/search_page.dart';
import 'package:native_app/features/sura/views/widgets/tilawat_page.dart';
import 'package:native_app/features/sura_list/views/sura_list_page.dart';
import 'package:native_app/widgets/error_pages/page_404.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../features/article/views/article_detail_screen.dart';
import '../features/article/views/article_list_screen.dart';
import '../features/bayan/views/bayan_detail_screen.dart' as bayan_feat;
import '../features/bayan/views/bayan_downloads_screen.dart' as bayan_feat;
import '../features/bayan/views/bayan_list_screen.dart' as bayan_feat;
import '../features/bayan/views/downloaded_bayan_screen.dart' as bayan_feat;
import '../features/book/views/book_detail_screen.dart';
import '../features/book/views/book_list_screen.dart';
import '../features/book/views/chapter_screen.dart' as book_feat;
import '../features/book/views/downloaded_book_screen.dart' as book_feat;
import '../features/book/views/downloads_screen.dart' as book_feat;
import '../features/book/views/subchapter_screen.dart' as book_feat;
import '../features/bookmarks/views/bookmarks_screen.dart';
import '../features/dua/views/dua_detail_screen.dart';
import '../features/dua/views/dua_list_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/location/views/location_screen.dart';
import '../features/madrasah/views/madrasah_detail_screen.dart';
import '../features/madrasah/views/madrasah_gallery_screen.dart';
import '../features/madrasah/views/madrasah_info_screen.dart';
import '../features/madrasah/views/madrasah_introduction_screen.dart';
import '../features/madrasah/views/madrasah_list_screen.dart';
import '../features/malfuzat/views/downloaded_malfuzat_screen.dart';
import '../features/malfuzat/views/malfuzat_detail_screen.dart';
import '../features/malfuzat/views/malfuzat_downloads_screen.dart';
import '../features/malfuzat/views/malfuzat_list_screen.dart';
import '../features/masail/views/ask_question_screen.dart';
import '../features/masail/views/downloaded_masail_screen.dart';
import '../features/masail/views/masail_detail_screen.dart';
import '../features/masail/views/masail_downloads_screen.dart';
import '../features/masail/views/masail_list_screen.dart';
import '../features/mosques/views/mosques_screen.dart';
import '../features/namaz_time/views/namaz_settings_screen.dart';
import '../features/namaz_time/views/namaz_time_detail_screen.dart';
import '../features/namaz_time/views/namaz_times_screen.dart';
import '../features/namaz_time/views/prayer_alarm_screen.dart';
import '../features/news/views/news_detail_screen.dart';
import '../features/news/views/news_list_screen.dart';
import '../features/page/views/about_screen.dart';
import '../features/page/views/contact_us_screen.dart';
import '../features/page/views/donation_screen.dart';
import '../features/page/views/important_matters_screen.dart';
import '../features/qiblah/views/qiblah_screen.dart';
import '../features/settings/views/settings_screen.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class AppRoutes {
  AppRoutes._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const Home()),
      GoRoute(path: '/qurans', builder: (_, __) => const QuranCatalogueScreen()),
      GoRoute(
        path: '/qurans/quran',
        builder: (_, state) {
          final path = state.uri.queryParameters['path'];
          final width = int.tryParse(state.uri.queryParameters['width'] ?? '');
          final height =
              int.tryParse(state.uri.queryParameters['height'] ?? '');
          final ext = state.uri.queryParameters['ext'];

          if (path == null || width == null || height == null || ext == null) {
            return const Page404();
          }

          return QuranViewerScreen(
            editionDir: Directory(path),
            imageWidth: width,
            imageHeight: height,
            imageExt: ext,
          );
        },
      ),
      GoRoute(path: '/qurans/sura-list', builder: (_, __) => const SuraListPage()),
      GoRoute(
        path: '/qurans/sura/:id',
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) return const Page404();
          final initialScrollIndex =
              int.tryParse(state.uri.queryParameters['scroll'] ?? '');
          return SurahPage(
            suraNumber: id,
            initialScrollIndex: initialScrollIndex,
          );
        },
      ),
      GoRoute(path: '/qurans/search', builder: (_, __) => const SearchPage()),
      GoRoute(
        path: '/qurans/tilawat',
        builder: (_, state) {
          final sura = int.tryParse(state.uri.queryParameters['sura'] ?? '');
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          if (sura == null || ayah == null) return const Page404();
          return TilawatPage(initialSuraNumber: sura, initialAyahNumber: ayah);
        },
      ),
      GoRoute(path: '/books', builder: (_, __) => const BookListScreen()),
      GoRoute(
        path: '/books/:id',
        builder: (_, __) =>
            PageStorage(bucket: _bucket, child: const BookDetailScreen()),
      ),
      GoRoute(
        path: '/books/:id/chapters/:chapter_id',
        builder: (_, __) => const book_feat.ChapterScreen(),
      ),
      GoRoute(
        path: '/books/:id/subchapters/:subchapter_id',
        builder: (_, __) => const book_feat.SubchapterScreen(),
      ),
      GoRoute(
        path: '/books/downloads',
        builder: (_, __) => const book_feat.DownloadsScreen(),
      ),
      GoRoute(
        path: '/books/downloads/:id',
        builder: (_, __) => const book_feat.DownloadedBookScreen(),
      ),
      GoRoute(path: '/bayans', builder: (_, __) => const bayan_feat.BayanListScreen()),
      GoRoute(
        path: '/bayans/:id',
        builder: (_, __) => const bayan_feat.BayanDetailScreen(),
      ),
      GoRoute(
        path: '/bayans/downloads',
        builder: (_, __) => const bayan_feat.BayanDownloadsScreen(),
      ),
      GoRoute(
        path: '/bayans/downloads/:id',
        builder: (_, __) => const bayan_feat.DownloadedBayanScreen(),
      ),
      GoRoute(path: '/malfuzat', builder: (_, __) => const MalfuzatListScreen()),
      GoRoute(
        path: '/malfuzat/:id',
        builder: (_, __) => const MalfuzatDetailScreen(),
      ),
      GoRoute(
        path: '/malfuzat/downloads',
        builder: (_, __) => const MalfuzatDownloadsScreen(),
      ),
      GoRoute(
        path: '/malfuzat/downloads/:id',
        builder: (_, __) => const DownloadedMalfuzatScreen(),
      ),
      GoRoute(path: '/masail', builder: (_, __) => const MasailListScreen()),
      GoRoute(path: '/masail/:id', builder: (_, __) => const MasailDetailScreen()),
      GoRoute(
        path: '/masail/ask-question',
        builder: (_, __) => const AskQuestionScreen(),
      ),
      GoRoute(
        path: '/masail/downloads',
        builder: (_, __) => const MasailDownloadsScreen(),
      ),
      GoRoute(
        path: '/masail/downloads/:id',
        builder: (_, __) => const DownloadedMasailScreen(),
      ),
      GoRoute(path: '/duas', builder: (_, __) => const DuaListScreen()),
      GoRoute(path: '/duas/:id', builder: (_, __) => const DuaDetailScreen()),
      GoRoute(path: '/articles', builder: (_, __) => const ArticleListScreen()),
      GoRoute(path: '/articles/:id', builder: (_, __) => const ArticleDetailScreen()),
      GoRoute(path: '/news', builder: (_, __) => const NewsListScreen()),
      GoRoute(path: '/news/:id', builder: (_, __) => const NewsDetailScreen()),
      GoRoute(path: '/madrasahs', builder: (_, __) => const MadrasahListScreen()),
      GoRoute(
        path: '/madrasahs/:id',
        builder: (_, __) => const MadrasahDetailScreen(),
      ),
      GoRoute(
        path: '/madrasahs/:id/introduction',
        builder: (_, __) => const MadrasahIntroductionScreen(),
      ),
      GoRoute(
        path: '/madrasahs/:id/gallery',
        builder: (_, __) => const MadrasahGalleryScreen(),
      ),
      GoRoute(
        path: '/madrasahs/:id/infos/:info_id',
        builder: (_, __) => const MadrasahInfoScreen(),
      ),
      GoRoute(path: '/namaz-times', builder: (_, __) => const NamazTimes()),
      GoRoute(
        path: '/namaz-times/:slug',
        builder: (_, __) => const NamazTimeDetailScreen(),
      ),
      GoRoute(
        path: '/namaz-times/settings',
        builder: (_, __) => const NamazSettings(),
      ),
      GoRoute(
        path: '/namaz-times/alarms',
        builder: (_, __) => const PrayerAlarmScreen(),
      ),
      GoRoute(path: '/location', builder: (_, __) => const LocationScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const Settings()),
      GoRoute(path: '/bookmarks', builder: (_, __) => const Bookmarks()),
      GoRoute(path: '/donation', builder: (_, __) => const DonationScreen()),
      GoRoute(path: '/qiblah', builder: (_, __) => const Qiblah()),
      GoRoute(path: '/mosques', builder: (_, __) => const Mosques()),
      GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
      GoRoute(path: '/contact-us', builder: (_, __) => const ContactUsScreen()),
      GoRoute(
        path: '/important-matters',
        builder: (_, __) => const ImportantMattersScreen(),
      ),
    ],
    errorBuilder: (_, __) => const Page404(),
  );

  static bool _isWakelockRoute(String path) {
    if (path.startsWith('/qurans')) return true;
    return RegExp(r'^/bayans/[^/]+$').hasMatch(path);
  }

  static String _lastPath = router.state.uri.path;

  static void initialize() {
    router.routerDelegate.addListener(() async {
      final currentPath = router.state.uri.path;
      if (currentPath == _lastPath) return;

      if (_isWakelockRoute(_lastPath) != _isWakelockRoute(currentPath)) {
        if (_isWakelockRoute(currentPath)) {
          await WakelockPlus.enable();
        } else {
          await WakelockPlus.disable();
        }
      }

      if (_lastPath == '/qurans/quran' && currentPath != '/qurans/quran') {
        await OrientationToggle.setPortrait();
      }

      _lastPath = currentPath;
    });

    if (_isWakelockRoute(_lastPath)) {
      WakelockPlus.enable();
    }
  }
}
