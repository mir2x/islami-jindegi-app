import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/app_theme_color.dart';

class FilterNestedItem extends ConsumerStatefulWidget {
  const FilterNestedItem({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.paramKey,
    required this.subitems,
    required this.subitemBuilder,
    this.queryProvider,
  });

  final String itemId;
  final String itemTitle;
  final String paramKey;
  final List<dynamic> subitems;
  final Function subitemBuilder;

  /// When provided, uses this instead of the global queryParamsProvider.
  final dynamic queryProvider;

  @override
  FilterNestedItemState createState() => FilterNestedItemState();
}

class FilterNestedItemState extends ConsumerState<FilterNestedItem> {
  bool isOpen = false;
  final ScrollController sectionController = ScrollController();

  toggleOpen() {
    setState(() {
      isOpen = !isOpen;

      if (isOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final ctx = GlobalObjectKey(widget.itemId).currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(
              ctx,
              duration: const Duration(milliseconds: 500),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    var paramsProvider = widget.queryProvider ?? queryParamsProvider;
    var qParams = ref.watch(paramsProvider);
    var isSelected = qParams.containsKey(widget.paramKey) &&
        widget.subitems
            .map((s) => s.id)
            .any((id) => id == qParams[widget.paramKey]);
    final expanded = isSelected || isOpen;

    return Container(
      key: GlobalObjectKey(widget.itemId),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: isSelected ? null : toggleOpen,
            child: Container(
              color: isSelected ? colors.highlight : null,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.itemTitle,
                      style: isSelected
                          ? textTheme.labelMedium
                          : textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: colors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
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
                      }),
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
