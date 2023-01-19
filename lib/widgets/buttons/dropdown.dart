import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:native_app/theme/colors.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.updateItem,
  });

  final List<Map<String, String>> items;
  final String? selectedValue;
  final void Function(String?)? updateItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<String>(
      value: selectedValue,
      items: items.map<DropdownMenuItem<String>>((Map item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['label']),
        );
      }).toList(),
      isExpanded: true,
      iconEnabledColor: ThemeColors.color3,
      dropdownDecoration: const BoxDecoration(
        color: ThemeColors.color6,
      ),
      offset: const Offset(0, 5),
      onChanged: updateItem,
    );
  }
}
