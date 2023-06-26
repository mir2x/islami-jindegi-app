import 'package:flutter/material.dart';

class NextPageSwipe extends StatelessWidget {
  const NextPageSwipe({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.child,
  });

  final Future? Function() onPrevious;
  final Future? Function() onNext;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) async {
        if (details.primaryVelocity! > 0) {
          return await onPrevious();
        } else if (details.primaryVelocity! < 0) {
          return await onNext();
        }
      },
      child: child,
    );
  }
}
