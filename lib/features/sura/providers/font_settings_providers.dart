import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for SharedPreferences
const String _arabicFontKey = 'sura_arabic_font';
const String _arabicFontSizeKey = 'sura_arabic_font_size';
const String _bengaliFontKey = 'sura_bengali_font';
const String _bengaliFontSizeKey = 'sura_bengali_font_size';

// Arabic Font Provider
class ArabicFontNotifier extends Notifier<String> {
  @override
  String build() {
    _loadFromPrefs();
    return 'arabic/noorehuda';
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
    NotifierProvider<ArabicFontNotifier, String>(ArabicFontNotifier.new);

// Arabic Font Size Provider
class ArabicFontSizeNotifier extends Notifier<double> {
  @override
  double build() {
    _loadFromPrefs();
    return 30.0;
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
    NotifierProvider<ArabicFontSizeNotifier, double>(ArabicFontSizeNotifier.new);

// Bengali Font Provider
class BengaliFontNotifier extends Notifier<String> {
  @override
  String build() {
    _loadFromPrefs();
    return 'bangla/solaimanlipi';
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
    NotifierProvider<BengaliFontNotifier, String>(BengaliFontNotifier.new);

// Bengali Font Size Provider
class BengaliFontSizeNotifier extends Notifier<double> {
  @override
  double build() {
    _loadFromPrefs();
    return 14.0;
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

final bengaliFontSizeProvider = NotifierProvider<BengaliFontSizeNotifier,
    double>(BengaliFontSizeNotifier.new);
