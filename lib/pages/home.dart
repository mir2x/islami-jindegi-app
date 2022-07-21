import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islami Jindegi'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/icons/background-pattern-dark.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/quran.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/book.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/bayan.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/malfuzat.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/masail.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/dua.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/article.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/news.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/madrasah.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/icons/namaz-time.svg',
              ),
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
