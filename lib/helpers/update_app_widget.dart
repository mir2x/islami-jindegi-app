import 'package:home_widget/home_widget.dart';

void updateAppWidget(Map params) {
  HomeWidget.setAppGroupId('group.islami_jindegi');

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
    iOSName: 'AppWidget',
    qualifiedAndroidName: 'com.islami_jindegi.native_app.AppWidget',
  );
}
