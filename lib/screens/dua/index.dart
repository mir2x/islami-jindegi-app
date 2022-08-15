import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Dua extends StatelessWidget {
  const Dua({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Dua & Durud'),
      body: Center(
        child: Text(
          'List of Duas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
