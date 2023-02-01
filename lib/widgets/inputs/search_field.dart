import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/theme/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.onUpdate,
    this.labelText = 'Search',
  });

  final Function onUpdate;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return TextField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.color3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.color3),
        ),
        labelText: labelText,
        labelStyle: textTheme.labelMedium,
        constraints: const BoxConstraints(maxHeight: 45),
      ),
      onChanged: (value) {
        EasyDebounce.debounce(
          'search-debouncer',
          const Duration(milliseconds: 1000),
          () => onUpdate(value),
        );
      },
      style: textTheme.labelMedium,
    );
  }
}
