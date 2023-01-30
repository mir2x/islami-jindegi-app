import 'package:flutter/material.dart';

class Bismillah extends StatelessWidget {
  const Bismillah({
    super.key,
    required this.chapter,
  });

  final dynamic chapter;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    if (chapter.position != 9 || chapter.runtimeType.toString() != 'Surah') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Text(
          'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
          textAlign: TextAlign.right,
          softWrap: false,
          style: textTheme.headlineLarge?.copyWith(
            fontFamily: 'arabic/al-qalam',
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
