import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/theme/themes.dart';
import 'routes/index.dart';
import 'screens/error_pages/page_404.dart';
import 'package:native_app/local_server/db/local_database.dart';
import 'dart:convert';
import 'main.data.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  final database = LocalDatabase();

  QR.settings.pagesType = const QSlidePage();
  QR.settings.notFoundPage = QRoute(
    path: '/error-pages/404',
    builder: () => const Page404(),
  );

  final container = ProviderContainer(
    overrides: [configureRepositoryLocalStorage()],
  );

  await container.read(repositoryInitializerProvider.future);

  final allMasails = await database.select(database.masails).get();

  allMasails.forEach((masail) {
    print('Masails in database: ${masail.toJson()}');
  });

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(AppRoutes().routes),
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
