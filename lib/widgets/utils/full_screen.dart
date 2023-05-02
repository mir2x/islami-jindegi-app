import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/preferences.dart';

class FullScreen extends ConsumerWidget {
  const FullScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: theme == 'dark'
                  ? const AssetImage(
                      'assets/images/icons/background-pattern-dark.png',
                    )
                  : const AssetImage(
                      'assets/images/icons/background-pattern-light.png',
                    ),
              repeat: ImageRepeat.repeat,
            ),
          ),
        );
      },
    );
  }
}
