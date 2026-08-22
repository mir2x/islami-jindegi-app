import 'package:home_widget/home_widget.dart';

Future<void> updateAppWidget(Map params) async {
  await HomeWidget.setAppGroupId('group.islami_jindegi');

  await Future.wait(
    params.entries.map((entry) {
      final key = entry.key as String;
      final value = entry.value;
      if (value is int) {
        return HomeWidget.saveWidgetData<int>(key, value);
      } else {
        return HomeWidget.saveWidgetData<String>(key, value.toString());
      }
    }),
  );

  await Future.wait([
    'AppWidget',
    'HijriPrayerWidget',
    'PrayerScheduleWidget',
  ].map(
    (widgetName) => HomeWidget.updateWidget(
      name: widgetName,
      androidName: widgetName,
      iOSName: widgetName,
      qualifiedAndroidName:
          'com.islami_jindegi.native_app.$widgetName',
    ),
    ),
  );
}
