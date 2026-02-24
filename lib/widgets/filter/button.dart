import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/helpers/trancate_with_ellipsis.dart';

class FilterButton extends ConsumerWidget {
  const FilterButton({
    super.key,
    required this.children,
    this.label,
    this.active = false,
    required this.selectedItemLabel,
    this.selectedItemProvider,
  });

  final List<Widget> children;
  final String? label;
  final bool active;
  final Function(dynamic) selectedItemLabel;

  /// Riverpod provider that returns an AsyncValue of the selected item.
  final dynamic selectedItemProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String filterLabel = label ?? locales.filter;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return OutlinedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                double screenWidth = MediaQuery.of(context).size.width;
                double screenHeight = MediaQuery.of(context).size.height;

                return Dialog(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.8,
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 25,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      children: children,
                    ),
                  ),
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppTheme.inputBorderOutlineColor[theme]),
            backgroundColor:
                active == true ? AppTheme.inputSelectedBgColor[theme] : null,
            padding: EdgeInsets.only(
              left: isSmallMobile ? 10 : 12,
              right: isSmallMobile ? 6 : 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            minimumSize: const Size.fromHeight(45),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectedItemProvider != null) ...[
                Builder(
                  builder: (context) {
                    var asyncValue = ref.watch(selectedItemProvider);

                    if (asyncValue is AsyncLoading) {
                      return const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    } else if (asyncValue is AsyncError) {
                      return Text(filterLabel, style: textTheme.labelMedium);
                    } else if (asyncValue is AsyncData &&
                        asyncValue.value != null) {
                      String label = selectedItemLabel(asyncValue.value);
                      int cutoff = isSmallMobile ? 13 : 15;
                      return Text(
                        truncateWithEllipsis(label, cutoff),
                        style: textTheme.labelMedium,
                      );
                    }
                    return Text(filterLabel, style: textTheme.labelMedium);
                  },
                ),
              ] else ...[
                Text(
                  filterLabel,
                  style: textTheme.labelMedium,
                ),
              ],
              Icon(
                Icons.arrow_drop_down,
                color: AppTheme.iconColor[theme],
              ),
            ],
          ),
        );
      },
    );
  }
}
