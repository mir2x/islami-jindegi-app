import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueryParamsNotifier extends AutoDisposeNotifier<Map<String, dynamic>> {
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
    NotifierProvider.autoDispose<QueryParamsNotifier, Map<String, dynamic>>(
  () {
    return QueryParamsNotifier();
  },
);
