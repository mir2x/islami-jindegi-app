import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'resource.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SvgPicture.asset(
            'assets/images/logos/logo.svg',
            fit: BoxFit.scaleDown,
            width: 40,
            height: 35,
          ),
        ),
        title: const Text('Islami Jindegi'),
        backgroundColor: const Color(0xFF0a676a),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/images/icons/settings-icon.svg',
              fit: BoxFit.scaleDown,
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/icons/background-pattern-dark.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: GridView.count(
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
      ),
    );
  }
}
