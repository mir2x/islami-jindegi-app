import 'package:qlevar_router/qlevar_router.dart';
import '../screens/home/index.dart';
import '../screens/news/index.dart';

class AppRoutes {
  final routes = [
    QRoute(path: '/', builder: () => const Home()),
    QRoute(path: '/news', builder: () => const News())
  ];
}
