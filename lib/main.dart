import 'dart:async';
import 'dart:io' show Platform, HttpOverrides;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
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
import 'package:shared_preferences/shared_preferences.dart';
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

  // Load preferences before runApp so the correct theme is available
  // on the very first frame — avoids the theme flash/flicker.
  final initialPrefs = await SharedPreferences.getInstance();
  final initialTheme = initialPrefs.getString('theme') ?? 'classic';

  // Persist backend URL so the background Workmanager isolate (which never
  // calls main() and therefore has no dotenv) can reach the hijri backend.
  final hijriBackendUrl = dotenv.env['HIJRI_BACKEND_URL'];
  if (hijriBackendUrl != null) {
    await initialPrefs.setString('hijriBackendUrl', hijriBackendUrl);
  }

  await _primeHijriDateCache(initialPrefs);

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
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => UncontrolledProviderScope(
        container: container,
        child: MyApp(initialTheme: initialTheme),
      ),
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

Future<void> _primeHijriDateCache(SharedPreferences prefs) async {
  final backendUrl = prefs.getString('hijriBackendUrl');
  final countryCode = prefs.getString('countryCode') ?? 'BD';
  if (backendUrl == null || backendUrl.isEmpty || countryCode.isEmpty) {
    return;
  }

  final int hijriAdjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day + hijriAdjustment);
  final tomorrow =
      DateTime(now.year, now.month, now.day + hijriAdjustment + 1);
  final todayStr = _dateStr(today);
  final tomorrowStr = _dateStr(tomorrow);

  try {
    final dio = Dio(BaseOptions(
      baseUrl: '$backendUrl/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),);

    final results = await Future.wait([
      dio.get(
        '/hijri_date',
        queryParameters: {'date': todayStr, 'country-code': countryCode},
      ),
      dio.get(
        '/hijri_date',
        queryParameters: {'date': tomorrowStr, 'country-code': countryCode},
      ),
    ]);

    final todayData = results[0].data['data'];
    final tomorrowData = results[1].data['data'];

    if (todayData != null) {
      await prefs.setString(
        'hijriDataToday',
        jsonEncode({...Map<String, dynamic>.from(todayData), 'date': todayStr}),
      );
    }
    if (tomorrowData != null) {
      await prefs.setString(
        'hijriDataTomorrow',
        jsonEncode(
          {...Map<String, dynamic>.from(tomorrowData), 'date': tomorrowStr},
        ),
      );
    }
  } catch (_) {
    // Leave any existing cache in place; later code will fall back as needed.
  }
}

String _dateStr(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.initialTheme});

  final String initialTheme;

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
        final currentTheme = prefs?.getString('theme') ?? initialTheme;
        final selectedTheme =
            currentTheme == 'light' ? lightTheme(fonts) : classicTheme(fonts);
        final selectedDarkTheme = darkTheme(fonts);
        final selectedThemeMode =
            currentTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoutes.router,
          builder: (context, child) {
            if (!kDebugMode) {
              return child ?? const SizedBox.shrink();
            }

            return DevicePreview.appBuilder(context, child);
          },
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
