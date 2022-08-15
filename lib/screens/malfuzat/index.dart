import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Malfuzat extends StatelessWidget {
  const Malfuzat({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Malfuzat'),
      body: Center(
        child: Text(
          'List of Malfuzats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
