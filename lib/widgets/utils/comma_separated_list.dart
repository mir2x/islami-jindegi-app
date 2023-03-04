import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:collection/collection.dart';

class CommaSeparatedList extends StatelessWidget {
  const CommaSeparatedList({
    super.key,
    required this.resources,
    required this.builder,
    this.alignment = WrapAlignment.start,
  });

  final List resources;
  final ItemWidgetBuilder builder;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final count = resources.length;
    return Wrap(
      alignment: alignment,
      children: <Widget>[
        ...resources.mapIndexed((index, resource) {
          if (index < (count - 1)) {
            return Wrap(
              children: [
                builder(context, resource, index),
                const Text(','),
                const SizedBox(width: 5),
              ],
            );
          } else {
            return builder(context, resource, index);
          }
        }),
      ],
    );
  }
}
