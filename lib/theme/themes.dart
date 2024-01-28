import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme(Map fonts) {
  return ThemeData(
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
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
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color4,
        fontSize: 17,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 14,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 14,
        letterSpacing: 0,
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
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeColors.color5,
      foregroundColor: ThemeColors.color4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ThemeColors.color4,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: ThemeColors.color5,
    ),
    dialogBackgroundColor: ThemeColors.color1,
  );
}

ThemeData lightTheme(Map fonts) {
  return ThemeData(
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 24,
      ),
      headlineMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
      ),
      headlineSmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
      ),
      titleLarge: TextStyle(
        color: ThemeColors.color8,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color8,
        fontSize: 17,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 14,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 14,
        letterSpacing: 0,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeColors.color3,
      foregroundColor: ThemeColors.color8,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeColors.color3,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: ThemeColors.color3,
    ),
    iconTheme: const IconThemeData(
      color: ThemeColors.color8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeColors.color3,
      foregroundColor: ThemeColors.color4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ThemeColors.color8,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: ThemeColors.color3,
    ),
    dialogBackgroundColor: ThemeColors.color3,
  );
}

ThemeData classicTheme(Map fonts) {
  return ThemeData(
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ThemeColors.color13,
        fontSize: 24,
      ),
      headlineMedium: TextStyle(
        color: ThemeColors.color13,
        fontSize: 20,
      ),
      headlineSmall: TextStyle(
        color: ThemeColors.color13,
        fontSize: 17,
      ),
      titleLarge: TextStyle(
        color: ThemeColors.color8,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color8,
        fontSize: 17,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color13,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color13,
        fontSize: 17,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color13,
        fontSize: 14,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color13,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color13,
        fontSize: 17,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color13,
        fontSize: 14,
        letterSpacing: 0,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeColors.color12,
      foregroundColor: ThemeColors.color3,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeColors.color12,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: ThemeColors.color12,
    ),
    iconTheme: const IconThemeData(
      color: ThemeColors.color8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeColors.color12,
      foregroundColor: ThemeColors.color4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ThemeColors.color8,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: ThemeColors.color14,
    ),
    dialogBackgroundColor: ThemeColors.color14,
  );
}
