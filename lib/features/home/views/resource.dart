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
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;
    bool isSmallMobile = screenWidth < 340;

    double iconSize;

    if (isMobile) {
      iconSize = isSmallMobile ? 36 : 42;
    } else {
      iconSize = 80;
    }

    final targetRoute = route.startsWith('/') ? route : '/$route';
    return InkWell(
      onTap: () => context.push(targetRoute),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 14,
          vertical: isMobile ? 14 : 18,
        ),
        decoration: BoxDecoration(
          color: appColors.cardBg.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: appColors.divider.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: appColors.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
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
            SizedBox(height: isMobile ? 8 : 12),
            Flexible(
              child: Text(
                title,
                style: isSmallMobile
                    ? textTheme.labelSmall?.copyWith(
                        height: 1.1,
                        color: appColors.primaryText,
                      )
                    : textTheme.labelMedium?.copyWith(
                        height: 1.1,
                        color: appColors.primaryText,
                      ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
