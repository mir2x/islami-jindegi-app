import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Quran extends StatelessWidget {
  const Quran({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Quran'),
      body: Center(
        child: Text(
          'List of Surahs',
          style: textTheme.labelMedium,
        ),
      ),
    );
  }
}
