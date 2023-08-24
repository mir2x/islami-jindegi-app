import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';

class Dropdown extends ConsumerWidget {
  const Dropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.updateItem,
    this.hint,
    this.allowClear = false,
  });

  final List<Map<String, dynamic>> items;
  final dynamic selectedValue;
  final Widget? hint;
  final void Function(dynamic) updateItem;
  final bool allowClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';
        Color iconColor =
            theme == 'dark' ? ThemeColors.color4 : ThemeColors.color8;

        return DropdownButton2<dynamic>(
          hint: hint,
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
                  ? Icon(Icons.arrow_drop_down, color: iconColor)
                  : IconButton(
                      icon: Icon(Icons.clear_outlined, color: iconColor),
                      iconSize: 15,
                      onPressed: () => updateItem(''),
                    )
              : Icon(Icons.arrow_drop_down, color: iconColor),
          dropdownDecoration: BoxDecoration(
            color: theme == 'dark' ? ThemeColors.color6 : ThemeColors.color3,
          ),
          offset: const Offset(0, 5),
          onChanged: updateItem,
        );
      },
    );
  }
}
