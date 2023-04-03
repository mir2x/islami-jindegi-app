import 'package:flutter/material.dart';

class PreviousNext extends StatelessWidget {
  const PreviousNext({
    super.key,
    required this.onPrevious,
    required this.onNext,
    this.previousDisabled = false,
    this.nextDisabled = false,
  });

  final void Function() onPrevious;
  final void Function() onNext;
  final bool previousDisabled;
  final bool nextDisabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
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
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: nextDisabled ? Colors.grey : null,
          padding: const EdgeInsets.only(
            top: 10,
            right: 10,
            bottom: 10,
            left: 5,
          ),
          constraints: const BoxConstraints(),
          onPressed: onNext,
        ),
      ],
    );
  }
}
