import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Donation extends StatelessWidget {
  const Donation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Donation'),
      body: Center(
        child: Text(
          'Info about Donation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
