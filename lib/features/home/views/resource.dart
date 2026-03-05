import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/icons/$icon.svg',
            fit: BoxFit.contain,
            width: iconSize,
            height: iconSize,
          ),
          Container(
            margin: EdgeInsets.only(top: isMobile ? 7 : 15),
            child: Text(
              title,
              style: isSmallMobile
                  ? textTheme.labelSmall?.copyWith(height: 1)
                  : textTheme.labelMedium?.copyWith(height: 1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
