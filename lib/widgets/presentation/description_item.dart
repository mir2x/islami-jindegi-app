import 'package:flutter/material.dart';

class DescriptionItem extends StatelessWidget {
  const DescriptionItem({
    super.key,
    required this.title,
    required this.description,
    this.alignment = CrossAxisAlignment.start,
  });

  final String title;
  final Widget description;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: alignment,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
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
