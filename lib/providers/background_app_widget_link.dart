import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:native_app/routes/index.dart';

final backgroundAppWidgetLinkProvider = Provider((ref) {
  HomeWidget.widgetClicked.listen(
    (Uri? uri) async {
      if (uri == null) return;

      final route = uri.queryParameters['route'];
      debugPrint('[AppWidget] widgetClicked: uri=$uri, route=$route');
      if (route != null && route.isNotEmpty) {
        AppRoutes.router.go('/');
        await Future.delayed(const Duration(milliseconds: 150));
        debugPrint('[AppWidget] navigating to $route');
        AppRoutes.router.push(route.startsWith('/') ? route : '/$route');
      }
    },
  );
});
