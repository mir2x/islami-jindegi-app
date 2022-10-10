import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/icons/background-pattern-dark.png'),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
