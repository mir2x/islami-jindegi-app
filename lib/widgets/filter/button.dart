import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/theme/app_theme_color.dart';

class FilterButton extends ConsumerWidget {
  const FilterButton({
    super.key,
    required this.children,
    this.label,
    this.active = false,
    required this.selectedItemLabel,
    this.selectedItemProvider,
    this.onClear,
  });

  final List<Widget> children;
  final String? label;
  final bool active;
  final Function(dynamic) selectedItemLabel;
  final VoidCallback? onClear;

  /// Riverpod provider that returns an AsyncValue of the selected item.
  final dynamic selectedItemProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    String filterLabel = label ?? locales.filter;

    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            double screenWidth = MediaQuery.of(dialogContext).size.width;
            double screenHeight = MediaQuery.of(dialogContext).size.height;

            return Dialog(
              backgroundColor: appTheme.dropdownBg,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: appTheme.divider),
              ),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  color: appTheme.dropdownBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 25,
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(filterLabel, style: textTheme.titleMedium),
                        if (active && onClear != null)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              onClear!();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        children: children,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: appTheme.divider),
        backgroundColor: active ? appTheme.highlight : appTheme.cardBg,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size.fromHeight(45),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: selectedItemProvider != null
                ? Builder(
                    builder: (context) {
                      var asyncValue = ref.watch(selectedItemProvider);

                      if (asyncValue is AsyncLoading) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      } else if (asyncValue is AsyncError) {
                        return Text(
                          filterLabel,
                          style: textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else if (asyncValue is AsyncData &&
                          asyncValue.value != null) {
                        return Text(
                          selectedItemLabel(asyncValue.value),
                          style: textTheme.labelMedium?.copyWith(
                            color: appTheme.primaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      }
                      return Text(
                        filterLabel,
                        style: textTheme.labelMedium?.copyWith(
                          color: appTheme.primaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    },
                  )
                : Text(
                    filterLabel,
                    style: textTheme.labelMedium?.copyWith(
                      color: appTheme.primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.arrow_drop_down,
            color: appTheme.secondaryText,
          ),
        ],
      ),
    );
  }
}
