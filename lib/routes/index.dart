import 'package:qlevar_router/qlevar_router.dart';
import '../screens/home/index.dart';

class AppRoutes {
  final routes = [
    QRoute(path: '/', builder: () => const Home())
  ];
}
