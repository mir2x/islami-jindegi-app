import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: ThemeColors.color5,
      onPrimary: ThemeColors.color3,
      secondary: ThemeColors.color2,
      onSecondary: ThemeColors.color3,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      background: ThemeColors.color2,
      onBackground: ThemeColors.color3,
      surface: ThemeColors.color2,
      onSurface: ThemeColors.color3,
    ),
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
      foregroundColor: ThemeColors.color3,
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
    dialogTheme: DialogTheme(
      backgroundColor: ThemeColors.color1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

ThemeData lightTheme(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ThemeColors.color3,
      onPrimary: ThemeColors.color2,
      secondary: ThemeColors.color3,
      onSecondary: ThemeColors.color2,
      error: ThemeColors.danger,
      onError: ThemeColors.color2,
      background: ThemeColors.color3,
      onBackground: ThemeColors.color2,
      surface: ThemeColors.color3,
      onSurface: ThemeColors.color2,
    ),
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
    dialogTheme: DialogTheme(
      backgroundColor: ThemeColors.color3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: ThemeColors.color6,
    ),
  );
}

ThemeData classicTheme(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ThemeColors.color12,
      onPrimary: ThemeColors.color13,
      secondary: ThemeColors.color11,
      onSecondary: ThemeColors.color13,
      error: ThemeColors.danger,
      onError: ThemeColors.color13,
      background: ThemeColors.color12,
      onBackground: ThemeColors.color13,
      surface: ThemeColors.color12,
      onSurface: ThemeColors.color13,
    ),
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
        color: ThemeColors.color2,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color2,
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
      tileColor: ThemeColors.color14,
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
    dialogTheme: DialogTheme(
      backgroundColor: ThemeColors.color14,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: ThemeColors.color13,
    ),
  );
}
