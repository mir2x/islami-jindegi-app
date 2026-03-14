import 'package:flutter/material.dart';

import 'app_theme_color.dart';
import 'colors.dart';

ThemeData darkTheme(Map fonts) {
  return classicTheme(fonts);
}

ThemeData lightTheme(Map fonts) {
  return classicTheme(fonts);
}

ThemeData classicTheme(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.light,
    colors: AppThemeColors.classic,
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
    textTheme: _buildLegacyTextTheme(
      headlineColor: ThemeColors.color13,
      titleColor: ThemeColors.color2,
      bodyColor: ThemeColors.color13,
      labelColor: ThemeColors.color13,
    ),
    appBarBackgroundColor: ThemeColors.color12,
    appBarForegroundColor: ThemeColors.color3,
    drawerBackgroundColor: ThemeColors.color12,
    listTileColor: ThemeColors.color14,
    iconColor: ThemeColors.color8,
    fabBackgroundColor: ThemeColors.color12,
    fabForegroundColor: ThemeColors.color4,
    progressColor: ThemeColors.color8,
    popupMenuColor: ThemeColors.color14,
    dialogBackgroundColor: ThemeColors.color14,
    snackBarBackgroundColor: ThemeColors.color13,
  );
}

ThemeData lightThemeNew(Map fonts) {
  return classicTheme(fonts);
}

ThemeData darkThemeNew(Map fonts) {
  return classicTheme(fonts);
}

ThemeData _buildTheme({
  required Map fonts,
  required Brightness brightness,
  required AppThemeColors colors,
  required ColorScheme colorScheme,
  required TextTheme textTheme,
  required Color appBarBackgroundColor,
  required Color appBarForegroundColor,
  required Color drawerBackgroundColor,
  Color? scaffoldBackgroundColor,
  Color? listTileColor,
  Color? iconColor,
  Color? fabBackgroundColor,
  Color? fabForegroundColor,
  Color? progressColor,
  Color? popupMenuColor,
  Color? dialogBackgroundColor,
  Color? snackBarBackgroundColor,
  Color? selectionColor,
  Color? selectionHandleColor,
  Color? dividerColor,
}) {
  return ThemeData(
    useMaterial3: false,
    brightness: brightness,
    extensions: [colors],
    fontFamily: fonts['fontFamily'],
    fontFamilyFallback: fonts['fontFamilyFallback'],
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: appBarBackgroundColor,
      foregroundColor: appBarForegroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: drawerBackgroundColor,
    ),
    listTileTheme: listTileColor == null
        ? null
        : ListTileThemeData(
            tileColor: listTileColor,
          ),
    iconTheme: iconColor == null
        ? null
        : IconThemeData(
            color: iconColor,
          ),
    floatingActionButtonTheme:
        fabBackgroundColor == null || fabForegroundColor == null
            ? null
            : FloatingActionButtonThemeData(
                backgroundColor: fabBackgroundColor,
                foregroundColor: fabForegroundColor,
              ),
    progressIndicatorTheme: progressColor == null
        ? null
        : ProgressIndicatorThemeData(
            color: progressColor,
          ),
    popupMenuTheme: popupMenuColor == null
        ? null
        : PopupMenuThemeData(
            color: popupMenuColor,
          ),
    dialogTheme: dialogBackgroundColor == null
        ? null
        : DialogTheme(
            backgroundColor: dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
    snackBarTheme: snackBarBackgroundColor == null
        ? null
        : SnackBarThemeData(
            backgroundColor: snackBarBackgroundColor,
          ),
    textSelectionTheme: selectionColor == null || selectionHandleColor == null
        ? null
        : TextSelectionThemeData(
            selectionColor: selectionColor,
            selectionHandleColor: selectionHandleColor,
          ),
    dividerColor: dividerColor,
  );
}

TextTheme _buildLegacyTextTheme({
  required Color headlineColor,
  required Color titleColor,
  required Color bodyColor,
  required Color labelColor,
}) {
  return TextTheme(
    headlineLarge: TextStyle(
      color: headlineColor,
      fontSize: 24,
      wordSpacing: 3,
    ),
    headlineMedium: TextStyle(
      color: headlineColor,
      fontSize: 20,
      wordSpacing: 3,
    ),
    headlineSmall: TextStyle(
      color: headlineColor,
      fontSize: 17,
      wordSpacing: 3,
    ),
    titleLarge: TextStyle(
      color: titleColor,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      wordSpacing: 3,
    ),
    titleMedium: TextStyle(
      color: titleColor,
      fontSize: 17,
      wordSpacing: 3,
    ),
    titleSmall: TextStyle(
      color: titleColor,
      fontSize: 14,
      wordSpacing: 3,
    ),
    bodyLarge: TextStyle(
      color: bodyColor,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      wordSpacing: 3,
    ),
    bodyMedium: TextStyle(
      color: bodyColor,
      fontSize: 17,
      wordSpacing: 3,
    ),
    bodySmall: TextStyle(
      color: bodyColor,
      fontSize: 14,
      letterSpacing: 0,
      wordSpacing: 3,
    ),
    labelLarge: TextStyle(
      color: labelColor,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      wordSpacing: 3,
    ),
    labelMedium: TextStyle(
      color: labelColor,
      fontSize: 17,
      wordSpacing: 3,
    ),
    labelSmall: TextStyle(
      color: labelColor,
      fontSize: 14,
      letterSpacing: 0,
      wordSpacing: 3,
    ),
  );
}
