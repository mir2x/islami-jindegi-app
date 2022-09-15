import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitRepository extends StatelessWidget {
  const InitRepository({
    super.key,
    required this.initializer,
    required this.data,
  });

  final AsyncValue initializer;
  final Widget Function(dynamic) data;

  @override
  Widget build(BuildContext context) {
    return initializer.when(
      data: data,
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
    );
  }
}
