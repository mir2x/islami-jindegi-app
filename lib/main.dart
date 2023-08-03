import 'dart:ui';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/themes.dart';
import 'package:native_app/widgets/utils/full_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'routes/index.dart';
import 'screens/error_pages/page_404.dart';
import 'firebase_options.dart';
import 'main.data.dart';

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

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter
  // framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  QR.settings.pagesType = const QSlidePage();
  QR.settings.notFoundPage = QRoute(
    path: '/error-pages/404',
    builder: () => const Page404(),
  );

  final container = ProviderContainer(
    overrides: [configureRepositoryLocalStorage()],
  );

  await container.read(repositoryInitializerProvider.future);

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
      loading: () => const FullScreen(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: const QRouteInformationParser(),
          routerDelegate: QRouterDelegate(AppRoutes().routes),
          theme: lightTheme(preferences),
          darkTheme: darkTheme(preferences),
          themeMode: theme == 'dark' ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(preferences.getString('locale') ?? 'bn'),
        );
      },
    );
  }
}
