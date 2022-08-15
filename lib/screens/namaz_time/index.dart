import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class NamazTime extends StatelessWidget {
  const NamazTime({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Namaz Time'),
      body: Center(
        child: Text(
          'List of Times',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
