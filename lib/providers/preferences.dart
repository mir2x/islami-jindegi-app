import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class PreferenceNotifier extends AsyncNotifier<SharedPreferences> {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  Future<dynamic> updateDaylight(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daylight', value);
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
    final nextTheme = switch (value) {
      'classic' || 'light' || 'dark' => value,
      _ => 'classic',
    };
    await prefs.setString('theme', nextTheme);
    updateAppWidget({'theme': nextTheme});
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateBackground(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('background', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateHijriLocalAdjustment(int value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hijriLocalAdjustment', value);
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
    if (value != null && int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('fajr', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateSunrise(value) async {
    if (value != null && int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('sunrise', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateDhuhr(value) async {
    if (value != null && int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dhuhr', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateAsr(value) async {
    if (value != null && int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('asr', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateMaghrib(value) async {
    if (value != null && int.tryParse(value) != null) {
      int intValue = int.parse(value);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('maghrib', intValue);
      state = AsyncValue.data(prefs);
    }
  }

  Future<dynamic> updateIsha(value) async {
    if (value != null && int.tryParse(value) != null) {
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
