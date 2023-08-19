import 'package:home_widget/home_widget.dart';

void updateAppWidget(Map params) {
  params.forEach((key, value) {
    if (value is int) {
      HomeWidget.saveWidgetData<int>(key, value);
    } else {
      HomeWidget.saveWidgetData<String>(key, value);
    }
  });

  HomeWidget.updateWidget(
    name: 'AppWidget',
    androidName: 'AppWidget',
    qualifiedAndroidName: 'com.islamidars.native_app.AppWidget',
  );
}
