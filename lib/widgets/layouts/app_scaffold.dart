import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.bottomBar,
    this.scaffoldKey,
    this.isHome = false,
  });

  final Text title;
  final Widget body;
  final Drawer? drawer;
  final Widget? bottomBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    final GlobalKey<ScaffoldState> sKey =
        scaffoldKey ?? GlobalKey<ScaffoldState>();

    return Scaffold(
      key: sKey,
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
                  onPressed: () async {
                    try {
                      await QR.back();
                    } catch (error) {
                      await QR.navigator.replaceAll('/');
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
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(locales.settings),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(locales.contactUs),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text(locales.shareThisApp),
                      ),
                      PopupMenuItem<int>(
                        value: 3,
                        child: Text(locales.rateThisApp),
                      ),
                      PopupMenuItem<int>(
                        value: 4,
                        child: Text(locales.iphoneAppLink),
                      ),
                      PopupMenuItem<int>(
                        value: 5,
                        child: Text(locales.websiteLink),
                      ),
                      PopupMenuItem<int>(
                        value: 6,
                        child: Text(locales.importantMatters),
                      ),
                    ],
                    onSelected: (int item) {
                      const appLink =
                          'https://play.google.com/store/apps/details?id=com.islamidars';

                      switch (item) {
                        case 0:
                          QR.to('settings');
                          break;
                        case 1:
                          QR.to('contact-us');
                          break;
                        case 2:
                          Share.share(appLink);
                          break;
                        case 3:
                          final Uri url = Uri.parse(appLink);
                          launchUrl(url);
                          break;
                        case 4:
                          final Uri url = Uri.parse(
                            'https://apps.apple.com/us/app/islamidars/id6447244518',
                          );
                          launchUrl(url);
                          break;
                        case 5:
                          final Uri url = Uri.parse('https://islamidars.com');
                          launchUrl(url);
                          break;
                        case 6:
                          QR.to('important-matters');
                          break;
                      }
                    },
                  )
                : GestureDetector(
                    onTap: () => sKey.currentState!.openEndDrawer(),
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
      drawer: drawer,
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
                  locales.home,
                  style: textTheme.titleLarge?.copyWith(fontSize: 24),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            DrawerLink(title: locales.quran, route: 'quran'),
            DrawerLink(title: locales.books, route: 'books'),
            DrawerLink(title: locales.bayans, route: 'bayans'),
            DrawerLink(title: locales.malfuzat, route: 'malfuzat'),
            DrawerLink(title: locales.masail, route: 'masail'),
            DrawerLink(title: locales.duaDurud, route: 'duas'),
            DrawerLink(title: locales.articles, route: 'articles'),
            DrawerLink(title: locales.news, route: 'news'),
            DrawerLink(title: locales.madrasah, route: 'madrasahs'),
            DrawerLink(title: locales.namazTime, route: 'namaz-times'),
            DrawerLink(title: locales.qiblah, route: 'qiblah'),
            DrawerLink(title: locales.donation, route: 'donation'),
            DrawerLink(title: locales.settings, route: 'settings'),
            DrawerLink(title: locales.bookmarks, route: 'bookmarks'),
            DrawerLink(title: locales.aboutUs, route: 'about'),
            DrawerLink(title: locales.contactUs, route: 'contact-us'),
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
      bottomNavigationBar: bottomBar,
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
