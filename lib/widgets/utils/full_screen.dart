import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'with_preferences.dart';

class FullScreen extends ConsumerWidget {
  const FullScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
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
