import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/themes.dart';
import 'package:native_app/widgets/utils/full_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'routes/index.dart';
import 'screens/error_pages/page_404.dart';
import 'main.data.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
