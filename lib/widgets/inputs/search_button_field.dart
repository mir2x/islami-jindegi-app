import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';
import 'input_field.dart';

class SearchButtonField extends ConsumerStatefulWidget {
  const SearchButtonField({
    super.key,
    required this.onUpdate,
    this.value,
    this.labelText,
    this.reverse = false,
    this.autofocus = false,
  });

  final String? value;
  final Function onUpdate;
  final String? labelText;
  final bool reverse;
  final bool autofocus;

  @override
  ConsumerState<SearchButtonField> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchButtonField> {
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

        return Directionality(
          textDirection: widget.reverse ? TextDirection.rtl : TextDirection.ltr,
          child: InputField(
            initialValue: widget.value,
            autofocus: widget.autofocus,
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
              contentPadding: EdgeInsets.only(
                top: 0,
                bottom: 0,
                left: widget.reverse ? 0 : 10,
                right: widget.reverse ? 10 : 0,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  widget.onUpdate(searchText);
                },
                icon: const Icon(Icons.search, color: ThemeColors.color4),
              ),
            ),
            onChanged: (value) {
              updateSearchText(value);

              if (value.isEmpty) {
                widget.onUpdate(value);
              }
            },
            style: textTheme.labelMedium,
          ),
        );
      },
    );
  }
}
