import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithPreferences extends ConsumerWidget {
  const WithPreferences({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, SharedPreferences preferences)
      builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        return builder(context, preferences);
      },
    );
  }
}
