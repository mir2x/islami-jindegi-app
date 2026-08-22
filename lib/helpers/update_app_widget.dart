import 'package:home_widget/home_widget.dart';

Future<void> updateAppWidget(Map params) async {
  await HomeWidget.setAppGroupId('group.islami_jindegi');

  // HomeWidget writes one SharedPreferences file. Platform calls made in
  // parallel can overwrite one another, leaving a widget with only some of
  // its fields. Save each value in order, then request one widget refresh.
  for (final entry in params.entries) {
    final key = entry.key as String;
    final value = entry.value;
    if (value is int) {
      await HomeWidget.saveWidgetData<int>(key, value);
    } else {
      await HomeWidget.saveWidgetData<String>(key, value.toString());
    }
  }

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
