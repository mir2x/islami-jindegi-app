import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Resource extends StatelessWidget {
  const Resource({required this.icon, required this.title, super.key});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/icons/$icon.svg',
          fit: BoxFit.scaleDown,
          width: 50,
          height: 50,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
