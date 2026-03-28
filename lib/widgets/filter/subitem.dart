import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/app_theme_color.dart';

class FilterSubitem extends ConsumerWidget {
  const FilterSubitem({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.paramKey,
    this.queryProvider,
  });

  final String itemId;
  final String itemTitle;
  final String paramKey;

  /// When provided, uses this instead of the global queryParamsProvider.
  final dynamic queryProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    var paramsProvider = queryProvider ?? queryParamsProvider;
    var qParams = ref.watch(paramsProvider);
    final isSelected =
        qParams.containsKey(paramKey) && qParams[paramKey] == itemId;

    return InkWell(
      onTap: () {
        ref.read(paramsProvider.notifier).updateParams(paramKey, itemId);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.highlight : null,
          border: Border(
            bottom: BorderSide(color: colors.divider),
          ),
        ),
        child: Text(
          itemTitle,
          style: isSelected ? textTheme.labelMedium : textTheme.titleMedium,
        ),
      ),
    );
  }
}
