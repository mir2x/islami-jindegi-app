import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

final launchAppWidgetLinkProvider = FutureProvider((ref) async {
  Uri? uri = await HomeWidget.initiallyLaunchedFromHomeWidget();

  if (uri != null) {
    QR.to(uri.queryParameters['route']!);
  }
});
