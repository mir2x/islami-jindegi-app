import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';

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
                  onPressed: QR.back,
                ),
        ),
        title: title,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: isHome ? 10 : 20),
            child: isHome
                ? GestureDetector(
                    onTap: () => QR.to('settings'),
                    child: SvgPicture.asset(
                      'assets/images/icons/settings-icon.svg',
                      fit: BoxFit.scaleDown,
                      width: 40,
                      height: 40,
                    ),
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
          children: const [
            DrawerLink(title: 'Quran', route: 'quran'),
            DrawerLink(title: 'Books', route: 'books'),
            DrawerLink(title: 'Bayans', route: 'bayans'),
            DrawerLink(title: 'Malfuzat', route: 'malfuzat'),
            DrawerLink(title: 'Masail', route: 'masail'),
            DrawerLink(title: 'Dua & Durud', route: 'duas'),
            DrawerLink(title: 'Articles', route: 'articles'),
            DrawerLink(title: 'News', route: 'news'),
            DrawerLink(title: 'Madrasah', route: 'madrasahs'),
            DrawerLink(title: 'Namaz Time', route: 'namaz-time'),
            DrawerLink(title: 'Donation', route: 'donation'),
            DrawerLink(title: 'Settings', route: 'settings'),
            DrawerLink(title: 'About Us', route: 'about'),
            DrawerLink(title: 'Contact Us', route: 'contact-us'),
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
