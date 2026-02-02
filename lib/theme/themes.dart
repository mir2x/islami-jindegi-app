import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: ThemeColors.color3,
      onPrimary: ThemeColors.color2,
      secondary: ThemeColors.color5,
      onSecondary: ThemeColors.color3,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      surface: ThemeColors.color5,
      onSurface: ThemeColors.color3,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 24,
        wordSpacing: 3,
      ),
      headlineMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
        wordSpacing: 3,
      ),
      headlineSmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
        wordSpacing: 3,
      ),
      titleLarge: TextStyle(
        color: ThemeColors.color4,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color4,
        fontSize: 17,
        wordSpacing: 3,
      ),
      titleSmall: TextStyle(
        color: ThemeColors.color4,
        fontSize: 14,
        wordSpacing: 3,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
        wordSpacing: 3,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 14,
        letterSpacing: 0,
        wordSpacing: 3,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color3,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color3,
        fontSize: 17,
        wordSpacing: 3,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color3,
        fontSize: 14,
        letterSpacing: 0,
        wordSpacing: 3,
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
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: ThemeColors.color8,
      selectionHandleColor: ThemeColors.color8,
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
      primary: ThemeColors.color2,
      onPrimary: ThemeColors.color3,
      secondary: ThemeColors.color8,
      onSecondary: ThemeColors.color3,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      surface: ThemeColors.color3,
      onSurface: ThemeColors.color2,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 24,
        wordSpacing: 3,
      ),
      headlineMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
        wordSpacing: 3,
      ),
      headlineSmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
        wordSpacing: 3,
      ),
      titleLarge: TextStyle(
        color: ThemeColors.color8,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color8,
        fontSize: 17,
        wordSpacing: 3,
      ),
      titleSmall: TextStyle(
        color: ThemeColors.color8,
        fontSize: 14,
        wordSpacing: 3,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
        wordSpacing: 3,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 14,
        letterSpacing: 0,
        wordSpacing: 3,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
        wordSpacing: 3,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 14,
        letterSpacing: 0,
        wordSpacing: 3,
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
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: ThemeColors.color4,
      selectionHandleColor: ThemeColors.color4,
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
      primary: ThemeColors.color13,
      onPrimary: ThemeColors.color3,
      secondary: ThemeColors.color12,
      onSecondary: ThemeColors.color3,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      surface: ThemeColors.color3,
      onSurface: ThemeColors.color12,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: ThemeColors.color13,
        fontSize: 24,
        wordSpacing: 3,
      ),
      headlineMedium: TextStyle(
        color: ThemeColors.color13,
        fontSize: 20,
        wordSpacing: 3,
      ),
      headlineSmall: TextStyle(
        color: ThemeColors.color13,
        fontSize: 17,
        wordSpacing: 3,
      ),
      titleLarge: TextStyle(
        color: ThemeColors.color2,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      titleMedium: TextStyle(
        color: ThemeColors.color2,
        fontSize: 17,
        wordSpacing: 3,
      ),
      titleSmall: TextStyle(
        color: ThemeColors.color2,
        fontSize: 14,
        wordSpacing: 3,
      ),
      bodyLarge: TextStyle(
        color: ThemeColors.color13,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      bodyMedium: TextStyle(
        color: ThemeColors.color13,
        fontSize: 17,
        wordSpacing: 3,
      ),
      bodySmall: TextStyle(
        color: ThemeColors.color13,
        fontSize: 14,
        letterSpacing: 0,
        wordSpacing: 3,
      ),
      labelLarge: TextStyle(
        color: ThemeColors.color13,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        wordSpacing: 3,
      ),
      labelMedium: TextStyle(
        color: ThemeColors.color13,
        fontSize: 17,
        wordSpacing: 3,
      ),
      labelSmall: TextStyle(
        color: ThemeColors.color13,
        fontSize: 14,
        letterSpacing: 0,
        wordSpacing: 3,
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
