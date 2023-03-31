import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceNotifier extends AsyncNotifier<SharedPreferences> {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  Future<dynamic> updateLocale(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateArabicFont(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('arabicFont', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateBanglaFont(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('banglaFont', value);
    state = AsyncValue.data(prefs);
  }
}

final preferencesProvider =
    AsyncNotifierProvider<PreferenceNotifier, SharedPreferences>(() {
  return PreferenceNotifier();
});
