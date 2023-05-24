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

    return GestureDetector(
      onTap: () => QR.to(route),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/icons/$icon.svg',
            fit: BoxFit.scaleDown,
            width: 42,
            height: 42,
          ),
          Container(
            margin: const EdgeInsets.only(top: 7),
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
