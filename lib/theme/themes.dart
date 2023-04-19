import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme(preferences) {
  return ThemeData(
    fontFamily: preferences.getString('banglaFont') ?? 'bangla/solaimanlipi',
    fontFamilyFallback: [
      preferences.getString('arabicFont') ?? 'arabic/al-qalam-quran-majeed',
    ],
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 24,
      ),
      headlineMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
      ),
      headlineSmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
      ),
      titleLarge: TextStyle(
        color: ThemeColors.color4,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color4,
        fontSize: 17,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 14,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeColors.color5,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeColors.color5,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: ThemeColors.color7,
    ),
    iconTheme: const IconThemeData(
      color: ThemeColors.color4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ThemeColors.color4,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: ThemeColors.color5,
    ),
  );
}
