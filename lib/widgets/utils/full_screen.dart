import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/icons/background-pattern-dark.png'),
          repeat: ImageRepeat.repeat,
        ),
      ),
    );
  }
}
