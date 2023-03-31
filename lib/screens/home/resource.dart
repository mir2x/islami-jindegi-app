import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter/material.dart';
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

    return GestureDetector(
      onTap: () => QR.to(route),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/icons/$icon.svg',
            fit: BoxFit.scaleDown,
            width: 40,
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            child: Text(
              title.toUpperCase(),
              style: textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
