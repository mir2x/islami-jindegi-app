import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/themes.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'routes/index.dart';
import 'screens/error_pages/page_404.dart';
import 'main.data.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

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
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: const QRouteInformationParser(),
          routerDelegate: QRouterDelegate(AppRoutes().routes),
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(preferences.getString('locale') ?? 'en'),
        );
      },
    );
  }
}
