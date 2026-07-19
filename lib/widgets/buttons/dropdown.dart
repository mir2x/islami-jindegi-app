import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Dropdown extends ConsumerStatefulWidget {
  const Dropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.updateItem,
    this.hint,
    this.searchEnabled = false,
    this.searchHint = 'Search for an item ...',
    this.allowClear = false,
  });

  final List<Map<String, dynamic>> items;
  final dynamic selectedValue;
  final Widget? hint;
  final void Function(dynamic) updateItem;
  final bool searchEnabled;
  final String searchHint;
  final bool allowClear;

  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends ConsumerState<Dropdown> {
  final TextEditingController textEditingController = TextEditingController();
  late final ValueNotifier<dynamic> _valueListenable =
      ValueNotifier<dynamic>(widget.selectedValue);

  @override
  void didUpdateWidget(covariant Dropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != _valueListenable.value) {
      _valueListenable.value = widget.selectedValue;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    Color iconColor = appTheme.secondaryText;

    return Container(
      decoration: BoxDecoration(
        color: appTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appTheme.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton2<dynamic>(
        isExpanded: true,
        hint: widget.hint,
        valueListenable: _valueListenable,
        items: widget.items.map<DropdownItem<dynamic>>((Map item) {
          return DropdownItem<dynamic>(
            value: item['value'],
            child: Text(
              item['label'],
              style: textTheme.bodyMedium?.copyWith(
                color: appTheme.primaryText,
              ),
            ),
          );
        }).toList(),
        iconStyleData: IconStyleData(
          icon: widget.allowClear
              ? widget.selectedValue == null
                  ? Icon(Icons.arrow_drop_down, color: iconColor)
                  : IconButton(
                      icon: Icon(Icons.clear_outlined, color: iconColor),
                      iconSize: 15,
                      onPressed: () => widget.updateItem(''),
                    )
              : Icon(Icons.arrow_drop_down, color: iconColor),
          iconEnabledColor: appTheme.secondaryText,
        ),
        buttonStyleData: const ButtonStyleData(
          height: 50,
          padding: EdgeInsets.zero,
        ),
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, 5),
          decoration: BoxDecoration(
            color: appTheme.dropdownBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appTheme.divider),
          ),
        ),
        dropdownSearchData: widget.searchEnabled
            ? DropdownSearchData(
                searchController: textEditingController,
                searchBarWidgetHeight: 60,
                searchBarWidget: Container(
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                      hintText: widget.searchHint,
                      hintStyle: textTheme.labelMedium,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appTheme.divider,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appTheme.divider,
                        ),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              )
            : null,
        underline: Container(
          height: 0,
        ),
        onChanged: widget.updateItem,
      ),
    );
  }
}
