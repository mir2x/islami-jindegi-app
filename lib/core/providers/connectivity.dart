import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Continuously reflects connectivity changes instead of caching launch state.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  yield !(await connectivity.checkConnectivity())
      .contains(ConnectivityResult.none);
  yield* connectivity.onConnectivityChanged
      .map((results) => !results.contains(ConnectivityResult.none));
});
