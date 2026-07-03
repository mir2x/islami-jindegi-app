import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_app/providers/push_notifications.dart';
import 'package:native_app/providers/launch_app_widget_link.dart';
import 'package:native_app/providers/background_app_widget_link.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/providers/notification_status.dart';
import 'package:native_app/theme/app_theme_color.dart';

const Set<String> _availableBackgroundAssets = {
  'assets/images/background/mosque-classic.png',
  'assets/images/background/mosque-light.png',
  'assets/images/background/mosque-dark.png',
  'assets/images/background/pattern-classic.png',
  'assets/images/background/pattern-light.png',
  'assets/images/background/pattern-dark.png',
};

String _resolveBackgroundAsset(String background, String theme) {
  final direct = 'assets/images/background/$background-$theme.png';
  if (_availableBackgroundAssets.contains(direct)) return direct;

  // Fallback to classic variant if theme-specific asset doesn't exist
  final fallback = 'assets/images/background/$background-classic.png';
  if (_availableBackgroundAssets.contains(fallback)) return fallback;

  return 'assets/images/background/mosque-classic.png';
}

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.bottomBar,
    this.onBackPressed,
    this.floatingActionButton,
    this.isHome = false,
    this.showAppBar = true,
    this.showBottomBar = true,
    this.showPattern = true,
    this.tabletBodyPadding = true,
    this.extraActions,
  });

  final Widget title;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomBar;
  final Function? onBackPressed;
  final Widget? floatingActionButton;
  final bool isHome;
  final bool showAppBar;
  final bool showBottomBar;
  final bool showPattern;
  final bool tabletBodyPadding;
  /// Optional widgets inserted between the notification button and the
  /// hamburger/menu button in the app bar.
  final List<Widget>? extraActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    ref.read(pushNotificationProvider);
    ref.read(launchAppWidgetLinkProvider);
    ref.read(backgroundAppWidgetLinkProvider);

    return WithPreferences(
      builder: (context, preferences) {
        final theme = switch (preferences.getString('theme')) {
          'classic' || 'light' || 'dark' => preferences.getString('theme')!,
          _ => 'classic',
        };
        final appColors = Theme.of(context).extension<AppThemeColors>()!;
        String background = preferences.getString('background') ?? 'mosque';
        final appBarBg =
            Theme.of(context).appBarTheme.backgroundColor ?? appColors.appBarBg;
        final useDarkHomeLogo =
            ThemeData.estimateBrightnessForColor(appBarBg) == Brightness.light;

        return PopScope(
          canPop: onBackPressed == null,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) return;
            await onBackPressed!();
          },
          child: Scaffold(
            backgroundColor: appColors.scaffoldBg,
            appBar: showAppBar
                ? AppBar(
                    backgroundColor: appBarBg,
                    foregroundColor: appColors.appBarText,
                    surfaceTintColor: Colors.transparent,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: isHome
                          ? useDarkHomeLogo
                              ? SvgPicture.asset(
                                  'assets/images/logos/logo-dark.svg',
                                  fit: BoxFit.scaleDown,
                                  width: 43,
                                  height: 35,
                                )
                              : SvgPicture.asset(
                                  'assets/images/logos/logo-light.svg',
                                  fit: BoxFit.scaleDown,
                                  width: 43,
                                  height: 35,
                                )
                          : IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: appColors.accent,
                              ),
                              onPressed: () async {
                                try {
                                  if (onBackPressed != null) {
                                    await onBackPressed!();
                                    if (!context.mounted) return;
                                  } else if (context.canPop()) {
                                    context.pop();
                                  }
                                } catch (error) {
                                  if (!context.mounted) return;
                                  context.go('/');
                                }
                              },
                            ),
                    ),
                    title: title,
                    centerTitle: true,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(1),
                      child: Container(
                        height: 1,
                        color: appColors.divider.withValues(alpha: 0.6),
                      ),
                    ),
                    actions: <Widget>[
                      const NotificationButton(),
                      ...?extraActions,
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: isHome
                            ? PopupMenuButton<int>(
                                child: const SizedBox(
                                  width: 45,
                                  height: 50,
                                  child: Icon(
                                    Icons.more_vert,
                                  ),
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Text(
                                      locales.settings,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Text(
                                      locales.contactUs,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: Text(
                                      locales.shareThisApp,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 3,
                                    child: Text(
                                      locales.rateThisApp,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 4,
                                    child: Text(
                                      Platform.isAndroid
                                          ? locales.iphoneAppLink
                                          : locales.androidAppLink,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 5,
                                    child: Text(
                                      locales.websiteLink,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 6,
                                    child: Text(
                                      locales.importantMatters,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                                onSelected: (int item) {
                                  const androidAppLink =
                                      'https://play.google.com/store/apps/details?id=com.islami_jindegi';

                                  const iOSAppLink =
                                      'https://apps.apple.com/app/islami-jindegi/id1271205014';

                                  String appLink = Platform.isAndroid
                                      ? androidAppLink
                                      : iOSAppLink;

                                  switch (item) {
                                    case 0:
                                      context.push('/settings');
                                      break;
                                    case 1:
                                      context.push('/contact-us');
                                      break;
                                    case 2:
                                      Share.share(appLink);
                                      break;
                                    case 3:
                                      final Uri url = Uri.parse(appLink);
                                      launchUrl(url);
                                      break;
                                    case 4:
                                      if (Platform.isAndroid) {
                                        final Uri url = Uri.parse(iOSAppLink);
                                        launchUrl(url);
                                      } else {
                                        final Uri url = Uri.parse(
                                          androidAppLink,
                                        );
                                        launchUrl(url);
                                      }
                                      break;
                                    case 5:
                                      final Uri url = Uri.parse(
                                        'https://islamijindegi.com',
                                      );
                                      launchUrl(url);
                                      break;
                                    case 6:
                                      context.push('/important-matters');
                                      break;
                                  }
                                },
                              )
                            : const MenuButton(),
                      ),
                    ],
                  )
                : null,
            drawer: drawer,
            endDrawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Drawer(
                backgroundColor: appColors.drawerBg,
                surfaceTintColor: Colors.transparent,
                child: SafeArea(
                  top: false,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(28, 56, 28, 24),
                        decoration: BoxDecoration(
                          color: appColors.drawerHeaderBg,
                          border: Border(
                            bottom: BorderSide(
                              color: appColors.divider.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'ইসলামী যিন্দেগী',
                              style: textTheme.headlineSmall?.copyWith(
                                color: appColors.appBarText,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      DrawerLink(title: locales.home, route: '/'),
                      DrawerLink(title: locales.quran, route: 'qurans'),
                      DrawerLink(title: locales.books, route: 'books'),
                      DrawerLink(title: locales.bayans, route: 'bayans'),
                      DrawerLink(title: locales.malfuzat, route: 'malfuzat'),
                      DrawerLink(title: locales.masail, route: 'masail'),
                      DrawerLink(title: locales.duaDurud, route: 'duas'),
                      DrawerLink(title: locales.articles, route: 'articles'),
                      DrawerLink(title: locales.news, route: 'news'),
                      DrawerLink(title: locales.madrasah, route: 'madrasahs'),
                      DrawerLink(
                        title: locales.namazTime,
                        route: 'namaz-times',
                      ),
                      DrawerLink(title: locales.qiblah, route: 'qiblah'),
                      DrawerLink(title: locales.mosques, route: 'mosques'),
                      DrawerLink(title: locales.donation, route: 'donation'),
                      DrawerLink(title: locales.location, route: 'location'),
                      DrawerLink(title: locales.settings, route: 'settings'),
                      DrawerLink(
                        title: locales.bookmarks,
                        route: 'bookmarks',
                      ),
                      DrawerLink(title: locales.aboutUs, route: 'about'),
                      DrawerLink(
                        title: locales.contactUs,
                        route: 'contact-us',
                      ),
                      DrawerAction(
                        title: locales.rateThisApp,
                        onTap: () {
                          final appLink = Platform.isAndroid
                              ? 'https://play.google.com/store/apps/details?id=com.islami_jindegi'
                              : 'https://apps.apple.com/app/islami-jindegi/id1271205014';
                          launchUrl(Uri.parse(appLink));
                        },
                      ),
                      DrawerAction(
                        title: locales.share,
                        isLast: true,
                        onTap: () {
                          final appLink = Platform.isAndroid
                              ? 'https://play.google.com/store/apps/details?id=com.islami_jindegi'
                              : 'https://apps.apple.com/app/islami-jindegi/id1271205014';
                          Share.share(appLink);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: (!isHome &&
                        showPattern &&
                        background != 'no-background')
                    ? DecorationImage(
                        image: AssetImage(
                          _resolveBackgroundAsset(background, theme),
                        ),
                        repeat: background == 'pattern'
                            ? ImageRepeat.repeat
                            : ImageRepeat.noRepeat,
                        fit: background == 'pattern'
                            ? BoxFit.none
                            : BoxFit.cover,
                        alignment: background == 'pattern'
                            ? Alignment.center
                            : Alignment.bottomCenter,
                      )
                    : null,
                color: Theme.of(context).extension<AppThemeColors>()!.surfaceBg,
              ),
              constraints: const BoxConstraints.expand(),
              child: SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 768) {
                      return body;
                    } else {
                      if (tabletBodyPadding) {
                        double screenWidth = MediaQuery.of(context).size.width;

                        return Container(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.06,
                            right: screenWidth * 0.06,
                          ),
                          child: body,
                        );
                      } else {
                        return body;
                      }
                    }
                  },
                ),
              ),
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: showBottomBar ? bottomBar : null,
          ),
        );
      },
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    return IconButton(
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      icon: SvgPicture.asset(
        'assets/images/icons/menu.svg',
        fit: BoxFit.scaleDown,
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(
          appColors.accent,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class DrawerLink extends StatelessWidget {
  const DrawerLink({
    super.key,
    required this.title,
    required this.route,
    this.isLast = false,
  });

  final String title;
  final String route;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final drawerTextColor =
        isClassic ? appColors.appBarText : appColors.primaryText;
    final isActive = GoRouterState.of(context).uri.path == '/' &&
        (route == '/' || route.isEmpty);

    return InkWell(
      onTap: () {
        Scaffold.of(context).closeEndDrawer();

        final target = route.startsWith('/') ? route : '/$route';
        final currentPath = GoRouterState.of(context).uri.path;
        if (currentPath != target) {
          if (target == '/') {
            context.go(target);
          } else {
            context.push(target);
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isActive
              ? appColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: appColors.divider.withValues(alpha: 0.25),
                  ),
                ),
        ),
        child: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: isActive ? appColors.primary : drawerTextColor,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}

class DrawerAction extends StatelessWidget {
  const DrawerAction({
    super.key,
    required this.title,
    required this.onTap,
    this.isLast = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final drawerTextColor =
        isClassic ? appColors.appBarText : appColors.primaryText;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: appColors.divider.withValues(alpha: 0.25),
                  ),
                ),
        ),
        child: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: drawerTextColor,
            fontWeight: FontWeight.w500,
          ),
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
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return statusProvider.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (PermissionStatus status) {
        if (status.isGranted || status.isProvisional) {
          return const SizedBox.shrink();
        } else {
          return IconButton(
            icon: Icon(
              Icons.notification_add,
              color: appColors.secondary,
            ),
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
