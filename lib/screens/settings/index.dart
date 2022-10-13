import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Settings'),
      body: Center(
        child: Text(
          'List of Settings',
          style: textTheme.labelMedium,
        ),
      ),
    );
  }
}
