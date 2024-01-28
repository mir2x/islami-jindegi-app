import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme.dart';
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
                    image: AssetImage(
                      'assets/images/background/pattern-$theme.png',
                    ),
                    repeat: ImageRepeat.repeat,
                  )
                : null,
            color: !showPattern ? AppTheme.backgroundColor[theme] : null,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
