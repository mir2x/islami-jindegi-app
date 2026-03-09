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
    final prefs = ref.watch(preferencesProvider);
    final loadedPrefs = prefs.value;
    if (loadedPrefs != null) {
      return builder(context, loadedPrefs);
    }

    // Fallback to direct shared_preferences load so UI can recover
    // even if provider initialization is delayed.
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!);
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
