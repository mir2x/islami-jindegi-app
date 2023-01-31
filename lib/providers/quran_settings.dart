import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranSettingsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void updateSettings(String key, String value) {
    if (value.isNotEmpty) {
      state = {
        ...state,
        key: value,
      };
    } else {
      state.remove(key);
      state = {...state};
    }
  }
}

final quranSettingsProvider =
    NotifierProvider<QuranSettingsNotifier, Map<String, dynamic>>(
  () {
    return QuranSettingsNotifier();
  },
);
