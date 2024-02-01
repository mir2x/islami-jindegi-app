import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';

class ListItem extends ConsumerWidget {
  const ListItem({
    super.key,
    required this.item,
    this.highlightProvider,
  });

  final Widget item;
  final dynamic highlightProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        AsyncValue? highlighter;

        if (highlightProvider != null) {
          highlighter = ref.watch(highlightProvider);
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: highlighter?.when(
              loading: () => null,
              error: (error, _) => null,
              data: (highlight) {
                if (highlight != null) {
                  return Border.all(color: ThemeColors.color4, width: 1);
                } else {
                  return null;
                }
              },
            ),
            borderRadius: BorderRadius.circular(15),
            color: AppTheme.listItemColor[theme],
          ),
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          child: item,
        );
      },
    );
  }
}
