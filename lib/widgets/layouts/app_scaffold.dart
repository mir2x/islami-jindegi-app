import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_app/providers/push_notifications.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/providers/notification_status.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.bottomBar,
    this.onBackPressed,
    this.scaffoldKey,
    this.isHome = false,
  });

  final Text title;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomBar;
  final Function? onBackPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    ref.read(pushNotificationProvider);
    var prefs = ref.watch(preferencesProvider);

    final GlobalKey<ScaffoldState> sKey =
        scaffoldKey ?? GlobalKey<ScaffoldState>();

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Scaffold(
          key: sKey,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: isHome
                  ? theme == 'dark'
                      ? SvgPicture.asset(
                          'assets/images/logos/logo.svg',
                          fit: BoxFit.scaleDown,
                          width: 40,
                          height: 35,
                        )
                      : SvgPicture.asset(
                          'assets/images/logos/logo-light.svg',
                          fit: BoxFit.scaleDown,
                          width: 40,
                          height: 35,
                        )
                  : IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        try {
                          onBackPressed != null
                              ? await onBackPressed!()
                              : await QR.back();
                        } catch (error) {
                          await QR.navigator.replaceAll('/');
                        }
                      },
                    ),
            ),
            title: title,
            centerTitle: true,
            actions: <Widget>[
              const NotificationButton(),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: isHome
                    ? PopupMenuButton<int>(
                        child: const SizedBox(
                          width: 40,
                          child: Icon(
                            Icons.more_vert,
                          ),
                        ),
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
                          const androidAppLink =
                              'https://play.google.com/store/apps/details?id=com.islamidars';

                          const iOSAppLink =
                              'https://apps.apple.com/app/islami-dars/id6447244518';

                          switch (item) {
                            case 0:
                              QR.to('settings');
                              break;
                            case 1:
                              QR.to('contact-us');
                              break;
                            case 2:
                              if (Platform.isAndroid) {
                                Share.share(androidAppLink);
                              } else if (Platform.isIOS) {
                                Share.share(iOSAppLink);
                              }
                              break;
                            case 3:
                              final Uri url = Uri.parse(androidAppLink);
                              launchUrl(url);
                              break;
                            case 4:
                              final Uri url = Uri.parse(iOSAppLink);
                              launchUrl(url);
                              break;
                            case 5:
                              final Uri url =
                                  Uri.parse('https://islamidars.com');
                              launchUrl(url);
                              break;
                            case 6:
                              QR.to('important-matters');
                              break;
                          }
                        },
                      )
                    : InkWell(
                        onTap: () => sKey.currentState!.openEndDrawer(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SvgPicture.asset(
                            'assets/images/icons/menu.svg',
                            fit: BoxFit.scaleDown,
                            width: 30,
                            height: 30,
                          ),
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
                InkWell(
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: theme == 'dark'
                    ? const AssetImage(
                        'assets/images/icons/background-pattern-dark.png',
                      )
                    : const AssetImage(
                        'assets/images/icons/background-pattern-light.png',
                      ),
                repeat: ImageRepeat.repeat,
              ),
            ),
            constraints: const BoxConstraints.expand(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 768) {
                  return body;
                } else {
                  double screenWidth = MediaQuery.of(context).size.width;

                  return Container(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.06,
                      right: screenWidth * 0.06,
                    ),
                    child: body,
                  );
                }
              },
            ),
          ),
          bottomNavigationBar: bottomBar,
        );
      },
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

    return InkWell(
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

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var statusProvider = ref.watch(notificationStatusProvider);

    return statusProvider.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (PermissionStatus status) {
        if (status.isGranted || status.isProvisional) {
          return const SizedBox.shrink();
        } else {
          return IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: () async {
              final messaging = FirebaseMessaging.instance;

              var permission = await messaging.requestPermission(
                alert: true,
                announcement: false,
                badge: true,
                carPlay: false,
                criticalAlert: false,
                provisional: true,
                sound: true,
              );

              var permissionStatus = permission.authorizationStatus;

              if (permissionStatus == AuthorizationStatus.authorized ||
                  permissionStatus == AuthorizationStatus.provisional) {
                await ref
                    .read(notificationStatusProvider.notifier)
                    .updateStatus();
              }

              if (permissionStatus == AuthorizationStatus.denied) {
                openAppSettings();
              }
            },
          );
        }
      },
    );
  }
}
