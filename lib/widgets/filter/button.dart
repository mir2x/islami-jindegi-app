import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/theme/colors.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.children,
    this.active = false,
  });

  final List<Widget> children;
  final bool active;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;

            return Dialog(
              backgroundColor: ThemeColors.color1,
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
        side: const BorderSide(color: ThemeColors.color3),
        backgroundColor: active == true ? ThemeColors.color1 : null,
        minimumSize: const Size.fromHeight(45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            active == true
                ? '${locales.filter} (${locales.active})'
                : locales.filter,
            style: textTheme.labelMedium,
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
