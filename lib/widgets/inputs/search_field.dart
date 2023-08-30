import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';
import 'input_field.dart';

class SearchField extends ConsumerWidget {
  const SearchField({
    super.key,
    required this.onUpdate,
    this.value,
    this.labelText,
    this.reverse = false,
    this.autofocus = false,
    this.maxHeight = 45,
  });

  final String? value;
  final Function(String) onUpdate;
  final String? labelText;
  final bool reverse;
  final bool autofocus;
  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Directionality(
          textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
          child: InputField(
            initialValue: value,
            autofocus: autofocus,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      theme == 'dark' ? ThemeColors.color3 : ThemeColors.color9,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      theme == 'dark' ? ThemeColors.color3 : ThemeColors.color9,
                ),
              ),
              labelText: labelText ?? locales.search,
              labelStyle: textTheme.labelMedium,
              constraints: BoxConstraints(maxHeight: maxHeight),
              contentPadding: EdgeInsets.only(
                top: 0,
                bottom: 0,
                left: reverse ? 0 : 10,
                right: reverse ? 10 : 0,
              ),
            ),
            onChanged: (value) {
              EasyDebounce.debounce(
                'search-debouncer',
                const Duration(milliseconds: 1000),
                () => onUpdate(value),
              );
            },
            style: textTheme.labelMedium,
          ),
        );
      },
    );
  }
}
