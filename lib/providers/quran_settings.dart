import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranSettingsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void updateParams(String key, dynamic value) {
    state = {
      ...state,
      key: value,
    };

    if (value is String && value.isEmpty) {
      state.remove(key);
      state = {...state};
    }
  }

  void updateMultipleParams(Map<String, dynamic> map) {
    state = {
      ...state,
      ...map,
    };
  }
}

final quranSettingsProvider =
    NotifierProvider<QuranSettingsNotifier, Map<String, dynamic>>(
  () {
    return QuranSettingsNotifier();
  },
);
