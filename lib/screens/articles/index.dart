import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Articles extends StatelessWidget {
  const Articles({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Articles'),
      body: Center(
        child: Text(
          'List of Articles',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
