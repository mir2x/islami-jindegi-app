import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/colors.dart';

class FilterNestedItem extends ConsumerStatefulWidget {
  const FilterNestedItem({
    super.key,
    required this.itemTitle,
    required this.paramKey,
    required this.subitems,
    required this.subitemBuilder,
  });

  final String itemTitle;
  final String paramKey;
  final HasMany subitems;
  final Function subitemBuilder;

  @override
  FilterNestedItemState createState() => FilterNestedItemState();
}

class FilterNestedItemState extends ConsumerState<FilterNestedItem> {
  bool isOpen = false;
  final ScrollController sectionController = ScrollController();

  toggleOpen() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);
    var isSelected = qParams.containsKey(widget.paramKey) &&
        widget.subitems
            .map((s) => s.id)
            .any((id) => id == qParams[widget.paramKey]);

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColors.color4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSelected) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.itemTitle,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.arrow_upward),
                ],
              ),
            ),
          ] else ...[
            InkWell(
              onTap: toggleOpen,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.itemTitle,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      isOpen ? Icons.arrow_upward : Icons.arrow_downward,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (isSelected || isOpen) ...[
            Container(
              padding: const EdgeInsets.only(
                left: 25,
                bottom: 5,
              ),
              constraints: const BoxConstraints(maxHeight: 150),
              child: Scrollbar(
                thumbVisibility: true,
                controller: sectionController,
                child: SingleChildScrollView(
                  controller: sectionController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.subitems.map((subitem) {
                        return widget.subitemBuilder(subitem);
                      })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
