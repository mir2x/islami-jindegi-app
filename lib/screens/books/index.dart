import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Books extends StatelessWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Books'),
      body: Center(
        child: Text(
          'List of Books',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
