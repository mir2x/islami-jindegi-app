import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    double sidePadding = isSmallMobile ? 13 : 16;

    return Directionality(
      textDirection: widget.reverse ? TextDirection.rtl : TextDirection.ltr,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appTheme.divider),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadow.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InputField(
          initialValue: widget.value,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: appTheme.divider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: appTheme.highlightBorder,
                width: 1.2,
              ),
            ),
            labelText: widget.labelText ?? locales.search,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: appTheme.secondaryText,
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
                color: appTheme.secondaryText,
              ),
            ),
          ),
          onChanged: (value) {
            updateSearchText(value);

            if (value.isEmpty) {
              widget.onUpdate(value);
            }
          },
          style: textTheme.labelMedium?.copyWith(
            color: appTheme.primaryText,
          ),
        ),
      ),
    );
  }
}
