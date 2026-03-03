import 'package:flutter/material.dart';
import 'app_theme_color.dart';
import 'colors.dart';
import 'app_colors.dart';

ThemeData darkTheme(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    extensions: const [AppThemeColors.dark],
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: ThemeColors.color4,
      onPrimary: ThemeColors.color2,
      primaryContainer: ThemeColors.color1,
      secondary: ThemeColors.color8,
      onSecondary: ThemeColors.color4,
      secondaryContainer: ThemeColors.color7,
      tertiary: ThemeColors.color8,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      surface: ThemeColors.color2,
      onSurface: ThemeColors.color3,
      surfaceContainerHighest: ThemeColors.color4,
      onSurfaceVariant: ThemeColors.color4,
      inverseSurface: ThemeColors.color1,
      onInverseSurface: ThemeColors.color3,
      inversePrimary: ThemeColors.color4,
      outline: ThemeColors.color3,
      outlineVariant: ThemeColors.color3,
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
    extensions: const [AppThemeColors.light],
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ThemeColors.color8,
      onPrimary: ThemeColors.color3,
      primaryContainer: ThemeColors.color9,
      secondary: ThemeColors.color10,
      onSecondary: ThemeColors.color9,
      secondaryContainer: ThemeColors.color10,
      tertiary: ThemeColors.color4,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      surface: ThemeColors.color3,
      onSurface: ThemeColors.color2,
      surfaceContainerHighest: ThemeColors.color10,
      onSurfaceVariant: ThemeColors.color8,
      inverseSurface: ThemeColors.color6,
      onInverseSurface: ThemeColors.color3,
      inversePrimary: ThemeColors.color4,
      outline: ThemeColors.color2,
      outlineVariant: ThemeColors.color9,
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
    extensions: const [AppThemeColors.light],
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ThemeColors.color3,
      onPrimary: ThemeColors.color13,
      primaryContainer: ThemeColors.color1,
      secondary: ThemeColors.color8,
      onSecondary: ThemeColors.color4,
      secondaryContainer: ThemeColors.color14,
      tertiary: ThemeColors.color4,
      error: ThemeColors.danger,
      onError: ThemeColors.color3,
      surface: ThemeColors.color11,
      onSurface: ThemeColors.color13,
      surfaceContainerHighest: ThemeColors.color14,
      onSurfaceVariant: ThemeColors.color8,
      inverseSurface: ThemeColors.color13,
      onInverseSurface: ThemeColors.color3,
      inversePrimary: ThemeColors.color4,
      outline: ThemeColors.color2,
      outlineVariant: ThemeColors.color9,
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

ThemeData lightThemeNew(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    extensions: const [AppThemeColors.light],
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    scaffoldBackgroundColor: AppColors.scaffoldBgLight,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.appBarTextLight,
      primaryContainer: AppColors.activeLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.primaryTextLight,
      secondaryContainer: AppColors.highlightLight,
      tertiary: AppColors.selectedItemLight,
      error: ThemeColors.danger,
      onError: AppColors.appBarTextLight,
      surface: AppColors.surfaceBgLight,
      onSurface: AppColors.primaryTextLight,
      surfaceContainerHighest: AppColors.cardBgLight,
      onSurfaceVariant: AppColors.secondaryTextLight,
      inverseSurface: AppColors.appBarBgLight,
      onInverseSurface: AppColors.appBarTextLight,
      inversePrimary: AppColors.primaryDark,
      outline: AppColors.dividerLight,
      outlineVariant: AppColors.dividerLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarBgLight,
      foregroundColor: AppColors.appBarTextLight,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.drawerBgLight,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.dropdownBgLight,
    ),
    dividerColor: AppColors.dividerLight,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryTextLight),
      bodyMedium: TextStyle(color: AppColors.primaryTextLight),
      bodySmall: TextStyle(color: AppColors.secondaryTextLight),
      titleLarge: TextStyle(color: AppColors.primaryTextLight),
      titleMedium: TextStyle(color: AppColors.primaryTextLight),
      titleSmall: TextStyle(color: AppColors.secondaryTextLight),
      labelLarge: TextStyle(color: AppColors.primaryTextLight),
      labelMedium: TextStyle(color: AppColors.secondaryTextLight),
      labelSmall: TextStyle(color: AppColors.secondaryTextLight),
    ),
  );
}

ThemeData darkThemeNew(Map fonts) {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    extensions: const [AppThemeColors.dark],
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    scaffoldBackgroundColor: AppColors.scaffoldBgDark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.primaryTextDark,
      primaryContainer: AppColors.activeDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.primaryTextDark,
      secondaryContainer: AppColors.highlightDark,
      tertiary: AppColors.selectedItemDark,
      error: ThemeColors.danger,
      onError: AppColors.primaryTextDark,
      surface: AppColors.surfaceBgDark,
      onSurface: AppColors.primaryTextDark,
      surfaceContainerHighest: AppColors.cardBgDark,
      onSurfaceVariant: AppColors.secondaryTextDark,
      inverseSurface: AppColors.appBarBgDark,
      onInverseSurface: AppColors.appBarTextDark,
      inversePrimary: AppColors.primaryLight,
      outline: AppColors.dividerDark,
      outlineVariant: AppColors.dividerDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarBgDark,
      foregroundColor: AppColors.appBarTextDark,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.drawerBgDark,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.dropdownBgDark,
    ),
    dividerColor: AppColors.dividerDark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryTextDark),
      bodyMedium: TextStyle(color: AppColors.primaryTextDark),
      bodySmall: TextStyle(color: AppColors.secondaryTextDark),
      titleLarge: TextStyle(color: AppColors.primaryTextDark),
      titleMedium: TextStyle(color: AppColors.primaryTextDark),
      titleSmall: TextStyle(color: AppColors.secondaryTextDark),
      labelLarge: TextStyle(color: AppColors.primaryTextDark),
      labelMedium: TextStyle(color: AppColors.secondaryTextDark),
      labelSmall: TextStyle(color: AppColors.secondaryTextDark),
    ),
  );
}
