import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'input_field.dart';

class SearchButtonField extends ConsumerStatefulWidget {
  const SearchButtonField({
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
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    double sidePadding = isSmallMobile ? 13 : 16;

    return Directionality(
      textDirection: widget.reverse ? TextDirection.rtl : TextDirection.ltr,
      child: InputField(
        initialValue: widget.value,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.divider,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.divider,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          filled: true,
          fillColor: colors.dropdownBg,
          labelText: widget.labelText ?? locales.search,
          labelStyle: textTheme.labelMedium,
          floatingLabelStyle: textTheme.labelMedium?.copyWith(
            fontSize: (textTheme.labelMedium?.fontSize ?? 17) + 1,
          ),
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          contentPadding: EdgeInsets.only(
            top: 0,
            bottom: 0,
            left: widget.reverse ? 0 : sidePadding,
            right: widget.reverse ? sidePadding : 0,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              if (searchText != null) {
                widget.onUpdate(searchText!);
              }
            },
            icon: Icon(
              Icons.search,
              color: colors.secondaryText,
            ),
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
  }
}
