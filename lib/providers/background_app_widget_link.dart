import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

final backgroundAppWidgetLinkProvider = Provider((ref) {
  HomeWidget.widgetClicked.listen(
    (Uri? uri) async {
      if (uri == null) return;

      final route = uri.queryParameters['route'];
      debugPrint('[AppWidget] widgetClicked: uri=$uri, route=$route');
      if (route != null && route.isNotEmpty) {
        await QR.navigator.replaceAll('/');
        await Future.delayed(const Duration(milliseconds: 150));
        debugPrint('[AppWidget] navigating to $route');
        await QR.to(route);
      }
    },
  );
});
