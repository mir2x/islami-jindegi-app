import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceNotifier extends AsyncNotifier<SharedPreferences> {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  Future<dynamic> updateHijriAdjustment(int value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hijriAdjustment', value);
    state = AsyncValue.data(prefs);
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

  Future<dynamic> updateTheme(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateMadhab(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('madhab', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateMethod(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('method', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateFajr(value) async {
    if (int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('fajr', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateSunrise(value) async {
    if (int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('sunrise', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateDhuhr(value) async {
    if (int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dhuhr', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateAsr(value) async {
    if (int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('asr', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateMaghrib(value) async {
    if (int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('maghrib', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateIsha(value) async {
    if (int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('isha', intValue);
      state = AsyncValue.data(prefs);
    }
  }
}

final preferencesProvider =
    AsyncNotifierProvider<PreferenceNotifier, SharedPreferences>(() {
  return PreferenceNotifier();
});
