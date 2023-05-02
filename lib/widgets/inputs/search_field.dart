import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';
import 'input_field.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({
    super.key,
    required this.onUpdate,
    this.value,
    this.labelText,
  });

  final String? value;
  final Function onUpdate;
  final String? labelText;

  @override
  ConsumerState<SearchField> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchField> {
  String? searchText;

  updateSearchText(value) {
    setState(() {
      searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return InputField(
          initialValue: widget.value,
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
            labelText: widget.labelText ?? locales.search,
            labelStyle: textTheme.labelMedium,
            constraints: const BoxConstraints(maxHeight: 45),
            suffixIcon: IconButton(
              onPressed: () {
                widget.onUpdate(searchText);
              },
              icon: const Icon(Icons.search, color: ThemeColors.color4),
            ),
          ),
          onChanged: updateSearchText,
          style: textTheme.labelMedium,
        );
      },
    );
  }
}
