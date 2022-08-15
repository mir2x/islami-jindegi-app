import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Masail extends StatelessWidget {
  const Masail({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Masail'),
      body: Center(
        child: Text(
          'List of Masail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
