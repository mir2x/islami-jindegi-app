import 'package:flutter/material.dart';

@immutable
class HomePaletteData {
  const HomePaletteData({
    required this.appBarBackground,
    required this.appBarForeground,
    required this.pageBackground,
    required this.heroTop,
    required this.heroBottom,
    required this.heroOverlay,
    required this.primaryTextOnHero,
    required this.secondaryTextOnHero,
    required this.prayerAccent,
    required this.locationChipBackground,
    required this.locationChipBorder,
    required this.mosqueAsset,
    required this.panelBackground,
    required this.panelBorder,
    required this.tileBackground,
    required this.tileBorder,
    required this.tileIcon,
    required this.tileText,
    required this.footerButtonBackground,
    required this.footerButtonText,
    required this.footerButtonBorder,
  });

  final Color appBarBackground;
  final Color appBarForeground;
  final Color pageBackground;
  final Color heroTop;
  final Color heroBottom;
  final Color heroOverlay;
  final Color primaryTextOnHero;
  final Color secondaryTextOnHero;
  final Color prayerAccent;
  final Color locationChipBackground;
  final Color locationChipBorder;
  final String mosqueAsset;
  final Color panelBackground;
  final Color panelBorder;
  final Color tileBackground;
  final Color tileBorder;
  final Color tileIcon;
  final Color tileText;
  final Color footerButtonBackground;
  final Color footerButtonText;
  final Color footerButtonBorder;
}

class HomePalette {
  HomePalette._();

  static const HomePaletteData classic = HomePaletteData(
    appBarBackground: Color(0xFF005248),
    appBarForeground: Color(0xFFF8F3E8),
    pageBackground: Color(0xFF0A5A51),
    heroTop: Color(0xFF6F938C),
    heroBottom: Color(0xFF213546),
    heroOverlay: Color(0x14000000),
    primaryTextOnHero: Color(0xFFF8F5ED),
    secondaryTextOnHero: Color(0xFFEDE7DB),
    prayerAccent: Color(0xFF48E1C2),
    locationChipBackground: Color(0xFF5A7E76),
    locationChipBorder: Color(0x26FFFFFF),
    mosqueAsset: 'assets/images/background/mosque-classic.png',
    panelBackground: Color(0xFFD8E9E4),
    panelBorder: Color(0xFFEAF5F2),
    tileBackground: Color(0xFFEAF4F0),
    tileBorder: Color(0xFF0A6A61),
    tileIcon: Color(0xFF0A6A61),
    tileText: Color(0xFF0A5A51),
    footerButtonBackground: Color(0xFFF8F3E8),
    footerButtonText: Color(0xFF0A5A51),
    footerButtonBorder: Color(0x1AFFFFFF),
  );

  static const HomePaletteData light = HomePaletteData(
    appBarBackground: Color(0xFFF4EEE2),
    appBarForeground: Color(0xFF1F241F),
    pageBackground: Color(0xFFF7F2E8),
    heroTop: Color(0xFF96B1A9),
    heroBottom: Color(0xFF58766E),
    heroOverlay: Color(0x10000000),
    primaryTextOnHero: Color(0xFFFCFAF6),
    secondaryTextOnHero: Color(0xFFF1ECE3),
    prayerAccent: Color(0xFF4EF0CF),
    locationChipBackground: Color(0xFF69867E),
    locationChipBorder: Color(0x24FFFFFF),
    mosqueAsset: 'assets/images/background/mosque-light.png',
    panelBackground: Color(0xFFFFFBF4),
    panelBorder: Color(0xFFE3D8C7),
    tileBackground: Color(0xFFF8F1E6),
    tileBorder: Color(0xFF215D4E),
    tileIcon: Color(0xFF215D4E),
    tileText: Color(0xFF215D4E),
    footerButtonBackground: Color(0xFFFFFFFF),
    footerButtonText: Color(0xFF215D4E),
    footerButtonBorder: Color(0x141F241F),
  );

  static const HomePaletteData dark = HomePaletteData(
    appBarBackground: Color(0xFF11161C),
    appBarForeground: Color(0xFFF2F0EA),
    pageBackground: Color(0xFF12161A),
    heroTop: Color(0xFF24353A),
    heroBottom: Color(0xFF12181D),
    heroOverlay: Color(0x1A000000),
    primaryTextOnHero: Color(0xFFF2F0EA),
    secondaryTextOnHero: Color(0xFFD0CCC3),
    prayerAccent: Color(0xFF7FC8A9),
    locationChipBackground: Color(0xFF25373C),
    locationChipBorder: Color(0x26FFFFFF),
    mosqueAsset: 'assets/images/background/mosque-dark.png',
    panelBackground: Color(0xFF1A2025),
    panelBorder: Color(0xFF2C343D),
    tileBackground: Color(0xFF20272E),
    tileBorder: Color(0xFF5F9F8D),
    tileIcon: Color(0xFF82CDB0),
    tileText: Color(0xFFF2F0EA),
    footerButtonBackground: Color(0xFF20272E),
    footerButtonText: Color(0xFFF2F0EA),
    footerButtonBorder: Color(0x1FFFFFFF),
  );

  static HomePaletteData fromThemeName(String themeName) {
    return switch (themeName) {
      'light' => light,
      'dark' => dark,
      _ => classic,
    };
  }
}
