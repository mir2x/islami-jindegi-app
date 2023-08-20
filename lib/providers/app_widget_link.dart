import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

void _launchedFromWidget(Uri? uri) {
  if (uri == null) return;

  QR.to(uri.queryParameters['route']!);
}

final appWidgetLinkProvider = FutureProvider((ref) async {
  Uri? uri = await HomeWidget.initiallyLaunchedFromHomeWidget();

  if (uri != null) {
    _launchedFromWidget(uri);
  } else {
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }
});
