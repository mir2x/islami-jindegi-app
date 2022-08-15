import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'resource.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Islami Jindegi'),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: const [
          Resource(icon: 'quran', title: 'Quran'),
          Resource(icon: 'book', title: 'Book'),
          Resource(icon: 'bayan', title: 'Bayan'),
          Resource(icon: 'malfuzat', title: 'Malfuzat'),
          Resource(icon: 'masail', title: 'Masail'),
          Resource(icon: 'dua', title: 'Dua & Durud'),
          Resource(icon: 'article', title: 'Articles'),
          Resource(icon: 'news', title: 'News'),
          Resource(icon: 'madrasah', title: 'Madrasah'),
          Resource(icon: 'namaz-time', title: 'Namaz Time'),
          Resource(icon: 'donate', title: 'Donation'),
          Resource(icon: 'settings', title: 'Settings'),
        ],
      ),
    );
  }
}
