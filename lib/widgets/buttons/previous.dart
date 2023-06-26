import 'package:flutter/material.dart';

class Previous extends StatelessWidget {
  const Previous({
    super.key,
    required this.onPrevious,
    this.previousDisabled = false,
  });

  final Future? Function() onPrevious;
  final bool previousDisabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: previousDisabled ? Colors.grey : null,
      padding: const EdgeInsets.only(
        top: 10,
        right: 5,
        bottom: 10,
        left: 10,
      ),
      constraints: const BoxConstraints(),
      onPressed: onPrevious,
    );
  }
}
