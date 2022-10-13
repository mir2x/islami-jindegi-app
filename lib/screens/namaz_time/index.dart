import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class NamazTime extends StatelessWidget {
  const NamazTime({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Namaz Time'),
      body: Center(
        child: Text(
          'List of Times',
          style: textTheme.labelMedium,
        ),
      ),
    );
  }
}
