import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityResultNotifier
    extends AsyncNotifier<List<ConnectivityResult>> {
  @override
  Future<List<ConnectivityResult>> build() async {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      var current = state.value;

      if (result.contains(ConnectivityResult.none) ||
          (current != null && current.contains(ConnectivityResult.none))) {
        state = AsyncValue.data(result);
      }
    });

    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult;
  }
}

final connectivityResultProvider =
    AsyncNotifierProvider<ConnectivityResultNotifier, List<ConnectivityResult>>(
        () {
  return ConnectivityResultNotifier();
});
