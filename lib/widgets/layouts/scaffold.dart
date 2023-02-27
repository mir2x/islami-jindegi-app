import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isHome = false,
  });

  final Text title;
  final Widget body;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: isHome
              ? SvgPicture.asset(
                  'assets/images/logos/logo.svg',
                  fit: BoxFit.scaleDown,
                  width: 40,
                  height: 35,
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (QR.navigator.canPop) {
                      QR.back();
                    } else {
                      QR.navigator.replaceAll('/');
                    }
                  },
                ),
        ),
        title: title,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: isHome ? 5 : 20),
            child: isHome
                ? PopupMenuButton<int>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text('Contact'),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text('Rate this app'),
                      ),
                      const PopupMenuItem<int>(
                        value: 3,
                        child: Text('iPhone App Link'),
                      ),
                      const PopupMenuItem<int>(
                        value: 4,
                        child: Text('Website Link'),
                      ),
                      const PopupMenuItem<int>(
                        value: 5,
                        child: Text('Important Matters'),
                      ),
                    ],
                    onSelected: (int item) {
                      switch (item) {
                        case 0:
                          QR.to('settings');
                          break;
                        case 1:
                          QR.to('contact-us');
                          break;
                        case 4:
                          final Uri url = Uri.parse('https://islamidars.com');
                          launchUrl(url);
                          break;
                        case 5:
                          QR.to('important-matters');
                          break;
                      }
                    },
                  )
                : GestureDetector(
                    onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                    child: SvgPicture.asset(
                      'assets/images/icons/menu.svg',
                      fit: BoxFit.scaleDown,
                      width: 30,
                      height: 30,
                    ),
                  ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                QR.navigator.replaceAll('/');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Home',
                  style: textTheme.titleLarge?.copyWith(fontSize: 24),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const DrawerLink(title: 'Quran', route: 'quran'),
            const DrawerLink(title: 'Books', route: 'books'),
            const DrawerLink(title: 'Bayans', route: 'bayans'),
            const DrawerLink(title: 'Malfuzat', route: 'malfuzat'),
            const DrawerLink(title: 'Masail', route: 'masail'),
            const DrawerLink(title: 'Dua & Durud', route: 'duas'),
            const DrawerLink(title: 'Articles', route: 'articles'),
            const DrawerLink(title: 'News', route: 'news'),
            const DrawerLink(title: 'Madrasah', route: 'madrasahs'),
            const DrawerLink(title: 'Namaz Time', route: 'namaz-times'),
            const DrawerLink(title: 'Donation', route: 'donation'),
            const DrawerLink(title: 'Settings', route: 'settings'),
            const DrawerLink(title: 'About Us', route: 'about'),
            const DrawerLink(title: 'Contact Us', route: 'contact-us'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/icons/background-pattern-dark.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: body,
      ),
    );
  }
}

class DrawerLink extends StatelessWidget {
  const DrawerLink({
    super.key,
    required this.title,
    required this.route,
  });

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        QR.to(route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: textTheme.titleLarge,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
