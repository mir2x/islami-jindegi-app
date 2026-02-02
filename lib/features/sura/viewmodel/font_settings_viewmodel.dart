import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for SharedPreferences
const String _arabicFontKey = 'sura_arabic_font';
const String _arabicFontSizeKey = 'sura_arabic_font_size';
const String _bengaliFontKey = 'sura_bengali_font';
const String _bengaliFontSizeKey = 'sura_bengali_font_size';

// Arabic Font Provider
class ArabicFontNotifier extends StateNotifier<String> {
  ArabicFontNotifier() : super('arabic/noorehuda') {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_arabicFontKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setFont(String font) async {
    state = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_arabicFontKey, font);
  }
}

final arabicFontProvider =
    StateNotifierProvider<ArabicFontNotifier, String>((ref) {
  return ArabicFontNotifier();
});

// Arabic Font Size Provider
class ArabicFontSizeNotifier extends StateNotifier<double> {
  ArabicFontSizeNotifier() : super(32.0) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_arabicFontSizeKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setSize(double size) async {
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, size);
  }
}

final arabicFontSizeProvider =
    StateNotifierProvider<ArabicFontSizeNotifier, double>((ref) {
  return ArabicFontSizeNotifier();
});

// Bengali Font Provider
class BengaliFontNotifier extends StateNotifier<String> {
  BengaliFontNotifier() : super('bangla/solaimanlipi') {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_bengaliFontKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setFont(String font) async {
    state = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bengaliFontKey, font);
  }
}

final bengaliFontProvider =
    StateNotifierProvider<BengaliFontNotifier, String>((ref) {
  return BengaliFontNotifier();
});

// Bengali Font Size Provider
class BengaliFontSizeNotifier extends StateNotifier<double> {
  BengaliFontSizeNotifier() : super(16.0) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_bengaliFontSizeKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setSize(double size) async {
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_bengaliFontSizeKey, size);
  }
}

final bengaliFontSizeProvider =
    StateNotifierProvider<BengaliFontSizeNotifier, double>((ref) {
  return BengaliFontSizeNotifier();
});
