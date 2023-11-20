import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithLastVisited extends ConsumerWidget {
  const WithLastVisited({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, SharedPreferences preferences)
      builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lastVisited = ref.watch(lastVisitedProvider);

    return lastVisited.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (settings) {
        return builder(context, settings);
      },
    );
  }
}
