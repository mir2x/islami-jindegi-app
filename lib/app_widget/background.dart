import 'package:home_widget/home_widget.dart';
import 'update_data.dart';

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? data) async {
  return await updateData();
}

Future setAppWidgetBackground() async {
  return await HomeWidget.registerInteractivityCallback(backgroundCallback);
}
