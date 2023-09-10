import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
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

    double iconSize;

    if (isMobile) {
      if (screenWidth < 340) {
        iconSize = 36;
      } else {
        iconSize = 42;
      }
    } else {
      iconSize = 80;
    }

    return InkWell(
      onTap: () => QR.to(route),
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
              style: textTheme.labelMedium?.copyWith(height: 1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
