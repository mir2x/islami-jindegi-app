import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/connectivity_result.dart';

class WithConnectivity extends ConsumerWidget {
  const WithConnectivity({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isConnected) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var connectivity = ref.watch(connectivityResultProvider);

    return connectivity.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (connectivityResult) {
        return builder(context, connectivityResult != ConnectivityResult.none);
      },
    );
  }
}
