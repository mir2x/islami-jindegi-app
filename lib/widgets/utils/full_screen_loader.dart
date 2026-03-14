import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';
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
        String background = preferences.getString('background') ?? 'mosque';
        final colors = Theme.of(context).extension<AppThemeColors>()!;

        return Container(
          decoration: BoxDecoration(
            image: (showPattern && background != 'no-background')
                ? DecorationImage(
                    image: AssetImage(
                      'assets/images/background/$background-classic.png',
                    ),
                    repeat: background == 'pattern'
                        ? ImageRepeat.repeat
                        : ImageRepeat.noRepeat,
                  )
                : null,
            color: colors.surfaceBg,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
