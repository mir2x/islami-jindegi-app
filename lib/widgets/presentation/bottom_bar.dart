import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return BottomAppBar(
          color: AppTheme.bottomBarColor[theme],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Row(
              mainAxisAlignment: alignment,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
