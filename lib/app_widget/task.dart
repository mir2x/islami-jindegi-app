import 'package:workmanager/workmanager.dart';
import 'update_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return await updateData();
  });
}
