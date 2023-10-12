import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/colors.dart';

class ListItem extends ConsumerWidget {
  const ListItem({
    super.key,
    required this.item,
  });

  final Widget item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme == 'dark' ? ThemeColors.color7 : ThemeColors.color10,
          ),
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          child: item,
        );
      },
    );
  }
}
