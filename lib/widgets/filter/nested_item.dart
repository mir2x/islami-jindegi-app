import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
          Scrollable.ensureVisible(
            GlobalObjectKey(widget.itemId).currentContext!,
            duration: const Duration(milliseconds: 500),
          );
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

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.divider,
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
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    'assets/images/icons/angle-up.svg',
                    fit: BoxFit.scaleDown,
                    width: 20,
                  ),
                ],
              ),
            ),
          ] else ...[
            InkWell(
              key: GlobalObjectKey(widget.itemId),
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
                    const SizedBox(width: 10),
                    isOpen
                        ? SvgPicture.asset(
                            'assets/images/icons/angle-up.svg',
                            fit: BoxFit.scaleDown,
                            width: 20,
                          )
                        : SvgPicture.asset(
                            'assets/images/icons/angle-down.svg',
                            fit: BoxFit.scaleDown,
                            width: 20,
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
