import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Bayans extends StatelessWidget {
  const Bayans({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Bayans'),
      body: Center(
        child: Text(
          'List of Bayans',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
