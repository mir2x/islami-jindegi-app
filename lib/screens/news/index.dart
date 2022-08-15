import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = List<String>.generate(50, (i) => 'News Item $i');

    return MyScaffold(
      title: const Text('News'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: ThemeColors().themeColor7,
            ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 15),
            child: Text(
              items[index],
              style: TextStyle(color: ThemeColors().themeColor4),
            ),
          );
        },
      ),
    );
  }
}
