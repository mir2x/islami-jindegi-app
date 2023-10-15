import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/colors.dart';
import 'with_preferences.dart';

class FullScreenLoader extends ConsumerWidget {
  const FullScreenLoader({
    super.key,
    this.showPattern = false,
  });

  final bool showPattern;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Container(
          decoration: BoxDecoration(
            image: showPattern
                ? DecorationImage(
                    image: theme == 'dark'
                        ? const AssetImage(
                            'assets/images/icons/background-pattern-dark.png',
                          )
                        : const AssetImage(
                            'assets/images/icons/background-pattern-light.png',
                          ),
                    repeat: ImageRepeat.repeat,
                  )
                : null,
            color: !showPattern
                ? theme == 'dark'
                    ? ThemeColors.color2
                    : ThemeColors.color3
                : null,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
