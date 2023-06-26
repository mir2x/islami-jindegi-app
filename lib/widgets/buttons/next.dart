import 'package:flutter/material.dart';

class Next extends StatelessWidget {
  const Next({
    super.key,
    required this.onNext,
    this.nextDisabled = false,
  });

  final Future? Function() onNext;
  final bool nextDisabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}
