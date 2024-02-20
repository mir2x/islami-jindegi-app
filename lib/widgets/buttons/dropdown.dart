import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';

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

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';
        Color iconColor = AppTheme.iconColor[theme];

        return DropdownButton2<dynamic>(
          isExpanded: true,
          hint: widget.hint,
          value: widget.selectedValue,
          items: widget.items.map<DropdownMenuItem<dynamic>>((Map item) {
            return DropdownMenuItem<dynamic>(
              value: item['value'],
              child: Text(item['label']),
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
            iconEnabledColor: ThemeColors.color3,
          ),
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, 5),
            decoration: BoxDecoration(
              color: AppTheme.dropdownColor[theme],
            ),
          ),
          dropdownSearchData: widget.searchEnabled
              ? DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
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
                            color: AppTheme.dropdownBorderOutlineColor[theme],
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.dropdownBorderOutlineColor[theme],
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
            height: 1.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.dropdownBorderOutlineColor[theme],
                  width: 0.0,
                ),
              ),
            ),
          ),
          onChanged: widget.updateItem,
        );
      },
    );
  }
}
