import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/theme/colors.dart';
import 'input_field.dart';

class SearchField extends StatefulWidget {
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
  State<SearchField> createState() => _SearchState();
}

class _SearchState extends State<SearchField> {
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

    return InputField(
      initialValue: widget.value,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.color3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.color3),
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
  }
}
