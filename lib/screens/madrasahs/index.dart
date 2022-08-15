import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Madrasahs extends StatelessWidget {
  const Madrasahs({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Madrasahs'),
      body: Center(
        child: Text(
          'List of Madrasahs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
