import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityResultNotifier extends AsyncNotifier<ConnectivityResult> {
  @override
  Future<ConnectivityResult> build() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none ||
          state.value == ConnectivityResult.none) {
        state = AsyncValue.data(result);
      }
    });

    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult;
  }
}

final connectivityResultProvider =
    AsyncNotifierProvider<ConnectivityResultNotifier, ConnectivityResult>(() {
  return ConnectivityResultNotifier();
});
