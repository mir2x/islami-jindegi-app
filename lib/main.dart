import 'dart:io' show Platform, HttpOverrides;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workmanager/workmanager.dart';
import 'package:lehttp_overrides/lehttp_overrides.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/themes.dart';
// --- 1. ADDED IMPORT ---
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes/index.dart';
import 'screens/error_pages/page_404.dart';
import 'firebase_options.dart';
import 'app_widget/task.dart';
import 'app_widget/background.dart';
import 'main.data.dart';
import 'package:quran_flutter/quran_flutter.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(kReleaseMode);

  if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter
    // framework to Crashlytics
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
  }

  QR.settings.pagesType = const QSlidePage(maintainState: true);
  QR.settings.notFoundPage = QRoute(
    path: '/error-pages/404',
    builder: () => const Page404(),
  );

  final container = ProviderContainer(
    overrides: [configureRepositoryLocalStorage()],
  );

  await container.read(repositoryInitializerProvider.future);

  if (Platform.isAndroid) {
    // fixes Let's Encrypt SSL certificate problems with Android 7.1.1 and below
    HttpOverrides.global = LEHttpOverrides();

    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      'app-widget-task',
      'appWidgetTask',
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 35),
    );

    await setAppWidgetBackground();
  }
  await Quran.initialize();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'classic';
        String banglaFont =
            preferences.getString('banglaFont') ?? 'bangla/solaimanlipi';
        String arabicFont =
            preferences.getString('arabicFont') ?? 'arabic/noorehuda';

        Map fonts = {
          'fontFamily': banglaFont,
          'fontFamilyFallback': ['Roboto', arabicFont],
        };

        // --- 2. WRAPPED MATERIALAPP WITH SCREENUTILINIT ---
        return ScreenUtilInit(
          // Set this to your design's width and height
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            // Return your MaterialApp.router here
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routeInformationParser: const QRouteInformationParser(),
              routerDelegate: QRouterDelegate(AppRoutes().routes),
              theme: theme == 'light' ? lightTheme(fonts) : classicTheme(fonts),
              darkTheme: darkTheme(fonts),
              themeMode: theme == 'dark' ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(preferences.getString('locale') ?? 'bn'),
            );
          },
        );
      },
    );
  }
}
