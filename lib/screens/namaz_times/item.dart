import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';

class NamazTimeItem extends ConsumerWidget {
  const NamazTimeItem({
    super.key,
    required this.label,
    required this.value,
    required this.onSelected,
  });

  final String label;
  final String value;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var prefs = ref.watch(preferencesProvider);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: prefs.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => Text(error.toString()),
            data: (preferences) {
              String theme = preferences.getString('theme') ?? 'dark';

              return InkWell(
                onTap: onSelected,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ThemeColors.color7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: textTheme.labelMedium?.copyWith(
                      color: theme == 'light' ? ThemeColors.color3 : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: onSelected,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ThemeColors.color3,
                border: Border.all(
                  color: ThemeColors.color2,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(
                  color: ThemeColors.color2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
