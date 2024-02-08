import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

final backgroundAppWidgetLinkProvider = Provider((ref) {
  HomeWidget.widgetClicked.listen(
    (Uri? uri) {
      if (uri == null) return;

      QR.to(uri.queryParameters['route']!);
    },
  );
});
