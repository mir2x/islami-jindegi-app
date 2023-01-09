import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:native_app/theme/colors.dart';

class FilterNestedItem extends ConsumerWidget {
  const FilterNestedItem({
    super.key,
    required this.itemTitle,
    required this.subitems,
    required this.subitemBuilder,
  });

  final String itemTitle;
  final HasMany subitems;
  final Function subitemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColors.color4,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemTitle,
            style: textTheme.titleMedium?.copyWith(
              color: ThemeColors.color8,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 25,
              top: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...subitems.map((subitem) {
                  return subitemBuilder(subitem);
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
