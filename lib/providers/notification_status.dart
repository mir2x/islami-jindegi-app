import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionNotifier extends AsyncNotifier<PermissionStatus> {
  @override
  Future<PermissionStatus> build() async {
    return await Permission.notification.status;
  }

  Future<dynamic> updateStatus() async {
    state = AsyncValue.data(await Permission.notification.status);
  }
}

final notificationStatusProvider =
    AsyncNotifierProvider<NotificationPermissionNotifier, PermissionStatus>(() {
  return NotificationPermissionNotifier();
});
