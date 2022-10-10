import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
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

  runApp(
    ProviderScope(
      overrides: [configureRepositoryLocalStorage()],
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
    );
  }
}
