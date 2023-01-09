import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/query_params.dart';

class FilterSubitem extends ConsumerWidget {
  const FilterSubitem({
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
        padding: const EdgeInsets.symmetric(vertical: 6),
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
