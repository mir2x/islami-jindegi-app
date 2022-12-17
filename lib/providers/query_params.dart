import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  QueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
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

final queryParamsProvider =
    StateNotifierProvider<QueryParamsNotifier, Map<String, dynamic>>(
  (ref) {
    return QueryParamsNotifier();
  },
);
