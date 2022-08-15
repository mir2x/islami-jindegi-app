import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Settings'),
      body: Center(
        child: Text(
          'List of Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
