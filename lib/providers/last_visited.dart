import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastVisitedNotifier extends AsyncNotifier<SharedPreferences> {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  Future<dynamic> updateLastSurah(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSurah', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastPara(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPara', value);
    state = AsyncValue.data(prefs);
  }
}

final lastVisitedProvider =
    AsyncNotifierProvider<LastVisitedNotifier, SharedPreferences>(() {
  return LastVisitedNotifier();
});
