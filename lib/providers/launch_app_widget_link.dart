import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

final launchAppWidgetLinkProvider = FutureProvider((ref) async {
  Uri? uri = await HomeWidget.initiallyLaunchedFromHomeWidget();

  if (uri != null) {
    final route = uri.queryParameters['route'];
    if (route != null && route.isNotEmpty) {
      // Delay to ensure this runs after the router's initial parse
      await Future.delayed(const Duration(milliseconds: 100));
      await QR.navigator.replaceAll('/');
      await QR.to(route);
    }
  }
});
