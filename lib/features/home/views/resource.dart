import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Resource extends StatelessWidget {
  const Resource({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  final String icon;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    final targetRoute = route.startsWith('/') ? route : '/$route';
    final tileBackground = isDarkTheme
        ? Color.alphaBlend(
            appColors.highlight.withValues(alpha: 0.42),
            appColors.cardBg,
          )
        : appColors.cardBg.withValues(alpha: 0.7);
    final tileBorderColor = isDarkTheme
        ? appColors.highlightBorder.withValues(alpha: 0.92)
        : appColors.divider.withValues(alpha: 0.4);
    final tileBorderWidth = isDarkTheme ? 1.15 : 1.0;

    return InkWell(
      onTap: () => context.push(targetRoute),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: tileBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: tileBorderColor,
            width: tileBorderWidth,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellHeight = constraints.maxHeight;

            // Scale icon and spacing based on available cell height
            double iconSize;
            double gap;
            double verticalPad;
            double horizontalPad;
            TextStyle? textStyle;

            if (!isMobile) {
              iconSize = 56;
              gap = 10;
              verticalPad = 14;
              horizontalPad = 12;
              textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
                    height: 1.1,
                    color: appColors.primaryText,
                  );
            } else if (cellHeight < 70) {
              iconSize = 20;
              gap = 2;
              verticalPad = 4;
              horizontalPad = 4;
              textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.1,
                    fontSize: 9,
                    color: appColors.primaryText,
                  );
            } else if (cellHeight < 85) {
              iconSize = cellHeight * 0.50;
              gap = cellHeight * 0.04;
              verticalPad = 0;
              horizontalPad = 4;
              textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.1,
                    fontSize: 13,
                    color: appColors.primaryText,
                  );
            } else {
              iconSize = cellHeight * 0.52;
              gap = cellHeight * 0.05;
              verticalPad = 0;
              horizontalPad = 4;
              textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
                    height: 1.1,
                    fontSize: 15,
                    color: appColors.primaryText,
                  );
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPad,
                vertical: verticalPad,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/$icon.svg',
                    fit: BoxFit.contain,
                    width: iconSize,
                    height: iconSize,
                  ),
                  SizedBox(height: gap),
                  Flexible(
                    child: Text(
                      title,
                      style: textStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
