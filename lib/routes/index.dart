import 'package:qlevar_router/qlevar_router.dart';
import '../pages/home.dart';

class AppRoutes {
  final routes = [
    QRoute(path: '/', builder: () => const Home())
  ];
}
