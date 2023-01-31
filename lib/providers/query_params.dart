import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueryParamsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

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
    NotifierProvider<QueryParamsNotifier, Map<String, dynamic>>(
  () {
    return QueryParamsNotifier();
  },
);
