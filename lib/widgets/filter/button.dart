import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';

class FilterButton extends ConsumerWidget {
  const FilterButton({
    super.key,
    required this.children,
    this.label,
    this.active = false,
  });

  final List<Widget> children;
  final String? label;
  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String filterLabel = label ?? locales.filter;

    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return OutlinedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                double screenWidth = MediaQuery.of(context).size.width;
                double screenHeight = MediaQuery.of(context).size.height;

                return Dialog(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.8,
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 25,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      children: children,
                    ),
                  ),
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: theme == 'dark' ? ThemeColors.color3 : ThemeColors.color9,
            ),
            backgroundColor: active == true
                ? theme == 'dark'
                    ? ThemeColors.color1
                    : ThemeColors.color3
                : null,
            minimumSize: const Size.fromHeight(45),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filterLabel,
                style: textTheme.labelMedium,
              ),
              const Icon(Icons.arrow_drop_down, color: ThemeColors.color4),
            ],
          ),
        );
      },
    );
  }
}
