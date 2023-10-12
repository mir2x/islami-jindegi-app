import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/colors.dart';

class SectionTitle extends ConsumerWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme == 'dark' ? ThemeColors.color7 : ThemeColors.color3,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Text(title),
        );
      },
    );
  }
}
