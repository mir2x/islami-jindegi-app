import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/colors.dart';

class FilterItem extends ConsumerWidget {
  const FilterItem({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.paramKey,
  });

  final String itemId;
  final String itemTitle;
  final String paramKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    return InkWell(
      onTap: () {
        ref
            .read(
              queryParamsProvider.notifier,
            )
            .updateParams(
              paramKey,
              itemId,
            );
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ThemeColors.color4,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          itemTitle,
          style: (qParams.containsKey(paramKey) && qParams[paramKey] == itemId)
              ? textTheme.labelMedium
              : textTheme.titleMedium,
        ),
      ),
    );
  }
}
