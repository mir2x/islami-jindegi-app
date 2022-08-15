import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';

class Quran extends StatelessWidget {
  const Quran({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: Text('Quran'),
      body: Center(
        child: Text(
          'List of Surahs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
