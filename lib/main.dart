import 'dart:async';
import 'dart:io' show Platform, HttpOverrides;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workmanager/workmanager.dart';
import 'package:lehttp_overrides/lehttp_overrides.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';

import 'routes/index.dart';
import 'firebase_options.dart';
import 'app_widget/task.dart';
import 'app_widget/background.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:timezone/data/latest.dart' as tz_data;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(fileName: '.env');
  tz_data.initializeTimeZones();

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

  AppRoutes.initialize();

  final container = ProviderContainer();

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

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );

  // Failsafe: ensure splash is removed even if first-frame callback is delayed.
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  widgetsBinding.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });

  unawaited(_initializeNonBlockingServices());
}

Future<void> _initializeNonBlockingServices() async {
  try {
    await PrayerAlarmService.initialize();
  } catch (error, stackTrace) {
    debugPrint('Prayer alarm initialization failed: $error\n$stackTrace');
  }

  try {
    await Quran.initialize();
  } catch (error, stackTrace) {
    debugPrint('Quran initialization failed: $error\n$stackTrace');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider).value;

    final banglaFont = prefs?.getString('banglaFont') ?? 'bangla/solaimanlipi';
    final arabicFont = prefs?.getString('arabicFont') ?? 'arabic/noorehuda';
    final locale = prefs?.getString('locale') ?? 'bn';

    final fonts = {
      'fontFamily': banglaFont,
      'fontFamilyFallback': ['Roboto', arabicFont],
    };

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final currentTheme = prefs?.getString('theme') ?? 'light';
        final selectedTheme =
            currentTheme == 'light' ? lightTheme(fonts) : classicTheme(fonts);
        final selectedDarkTheme = darkTheme(fonts);
        final selectedThemeMode =
            currentTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoutes.router,
          theme: selectedTheme,
          darkTheme: selectedDarkTheme,
          themeMode: selectedThemeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(locale),
        );
      },
    );
  }
}
