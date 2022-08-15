import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('News'),
      body: Center(
        child: Text(
          'List of News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
