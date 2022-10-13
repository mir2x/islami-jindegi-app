import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Donation extends StatelessWidget {
  const Donation({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Donation'),
      body: Center(
        child: Text(
          'Info about Donation',
          style: textTheme.labelMedium,
        ),
      ),
    );
  }
}
