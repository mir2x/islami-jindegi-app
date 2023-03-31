import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:native_app/theme/colors.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.updateItem,
    this.allowClear = false,
  });

  final List<Map<String, dynamic>> items;
  final dynamic selectedValue;
  final void Function(dynamic) updateItem;
  final bool allowClear;

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<dynamic>(
      value: selectedValue,
      items: items.map<DropdownMenuItem<dynamic>>((Map item) {
        return DropdownMenuItem<dynamic>(
          value: item['value'],
          child: Text(item['label']),
        );
      }).toList(),
      isExpanded: true,
      iconEnabledColor: ThemeColors.color3,
      icon: allowClear
          ? selectedValue == null
              ? const Icon(Icons.arrow_drop_down)
              : IconButton(
                  icon: const Icon(Icons.clear_outlined),
                  iconSize: 15,
                  onPressed: () => updateItem(''),
                )
          : const Icon(Icons.arrow_drop_down),
      dropdownDecoration: const BoxDecoration(
        color: ThemeColors.color6,
      ),
      offset: const Offset(0, 5),
      onChanged: updateItem,
    );
  }
}
