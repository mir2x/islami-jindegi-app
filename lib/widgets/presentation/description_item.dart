import 'package:flutter/material.dart';

class DescriptionItem extends StatelessWidget {
  const DescriptionItem({
    super.key,
    required this.title,
    required this.description,
    this.alignment = CrossAxisAlignment.start,
    this.textWidth = 125,
  });

  final String title;
  final Widget description;
  final CrossAxisAlignment alignment;
  final double textWidth;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: alignment,
        children: [
          SizedBox(
            width: textWidth,
            child: Text(
              title,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              child: description,
            ),
          ),
        ],
      ),
    );
  }
}
