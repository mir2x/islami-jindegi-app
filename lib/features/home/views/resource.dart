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
    final media = MediaQuery.of(context);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = media.size.width;
    final screenHeight = media.size.height;
    bool isMobile = screenWidth < 768;
    final isShortMobile = isMobile && screenHeight < 760;

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
            final cellWidth = constraints.maxWidth;
            final media = MediaQuery.of(context);
            final isShortHeightMobile =
                isMobile && media.size.height < 760;

            double iconSize;
            double gap;
            double verticalPad;
            double horizontalPad;
            double iconBoxHeightFactor;
            double textBoxHeightFactor;
            TextStyle? textStyle;

            if (!isMobile) {
              iconSize = 64;
              gap = 6;
              verticalPad = 4;
              horizontalPad = 4;
              iconBoxHeightFactor = 0.64;
              textBoxHeightFactor = 0.26;
              textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
                    height: 1.1,
                    color: appColors.primaryText,
                  );
            } else if (isShortHeightMobile) {
              iconSize = cellWidth * 0.60;
              gap = 0;
              verticalPad = 0;
              horizontalPad = 0;
              iconBoxHeightFactor = 0.68;
              textBoxHeightFactor = 0.26;
              textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.0,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: appColors.primaryText,
                  );
            } else if (cellHeight < 70) {
              iconSize = 22;
              gap = 2;
              verticalPad = 2;
              horizontalPad = 2;
              iconBoxHeightFactor = 0.58;
              textBoxHeightFactor = 0.24;
              textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.1,
                    fontSize: 9,
                    color: appColors.primaryText,
                  );
            } else if (cellHeight < 85) {
              iconSize = cellHeight * 0.56;
              gap = cellHeight * 0.02;
              verticalPad = 0;
              horizontalPad = 0;
              iconBoxHeightFactor = 0.62;
              textBoxHeightFactor = 0.24;
              textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.1,
                    fontSize: 13,
                    color: appColors.primaryText,
                  );
            } else {
              iconSize = cellHeight * 0.60;
              gap = cellHeight * 0.02;
              verticalPad = 0;
              horizontalPad = 0;
              iconBoxHeightFactor = 0.66;
              textBoxHeightFactor = 0.26;
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
                  SizedBox(
                    height: cellHeight * iconBoxHeightFactor,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/icons/$icon.svg',
                        fit: BoxFit.contain,
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                  ),
                  SizedBox(height: gap),
                  SizedBox(
                    height: cellHeight * textBoxHeightFactor,
                    child: Center(
                      child: Text(
                        title,
                        style: textStyle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
