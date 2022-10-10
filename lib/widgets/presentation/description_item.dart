import 'package:flutter/material.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class DescriptionItem extends StatelessWidget {
  const DescriptionItem({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors().themeColor3,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: description,
          ),
        ],
      ),
    );
  }
}
