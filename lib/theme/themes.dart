import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_color.dart';

ThemeData darkTheme(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.dark,
    colors: AppThemeColors.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.primaryTextDark,
      primaryContainer: AppColors.highlightDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.primaryTextDark,
      secondaryContainer: AppColors.cardBgDark,
      tertiary: AppColors.accentDark,
      error: AppColors.danger,
      onError: AppColors.primaryTextDark,
      surface: AppColors.surfaceBgDark,
      onSurface: AppColors.primaryTextDark,
      surfaceContainerHighest: AppColors.cardBgDark,
      onSurfaceVariant: AppColors.secondaryTextDark,
      inverseSurface: AppColors.surfaceBgLight,
      onInverseSurface: AppColors.primaryTextLight,
      inversePrimary: AppColors.primaryLight,
      outline: AppColors.dividerDark,
      outlineVariant: AppColors.highlightBorderDark,
    ),
    textTheme: _buildLegacyTextTheme(
      headlineColor: AppColors.primaryTextDark,
      titleColor: AppColors.primaryTextDark,
      bodyColor: AppColors.primaryTextDark,
      labelColor: AppColors.primaryTextDark,
    ),
    appBarBackgroundColor: AppColors.appBarBgDark,
    appBarForegroundColor: AppColors.appBarTextDark,
    drawerBackgroundColor: AppColors.drawerBgDark,
    scaffoldBackgroundColor: AppColors.scaffoldBgDark,
    listTileColor: AppColors.cardBgDark,
    iconColor: AppColors.primaryTextDark,
    fabBackgroundColor: AppColors.appBarBgDark,
    fabForegroundColor: AppColors.appBarTextDark,
    progressColor: AppColors.activeDark,
    popupMenuColor: AppColors.cardBgDark,
    dialogBackgroundColor: AppColors.cardBgDark,
    snackBarBackgroundColor: AppColors.cardBgDark,
    snackBarContentTextColor: AppColors.primaryTextDark,
    dividerColor: AppColors.dividerDark,
  );
}

ThemeData lightTheme(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.light,
    colors: AppThemeColors.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.appBarTextLight,
      primaryContainer: AppColors.highlightLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.primaryTextLight,
      secondaryContainer: AppColors.cardBgLight,
      tertiary: AppColors.accentLight,
      error: AppColors.danger,
      onError: AppColors.appBarTextLight,
      surface: AppColors.surfaceBgLight,
      onSurface: AppColors.primaryTextLight,
      surfaceContainerHighest: AppColors.cardBgLight,
      onSurfaceVariant: AppColors.secondaryTextLight,
      inverseSurface: AppColors.surfaceBgDark,
      onInverseSurface: AppColors.primaryTextDark,
      inversePrimary: AppColors.primaryDark,
      outline: AppColors.dividerLight,
      outlineVariant: AppColors.highlightBorderLight,
    ),
    textTheme: _buildLegacyTextTheme(
      headlineColor: AppColors.primaryTextLight,
      titleColor: AppColors.primaryTextLight,
      bodyColor: AppColors.primaryTextLight,
      labelColor: AppColors.primaryTextLight,
    ),
    appBarBackgroundColor: AppColors.appBarBgLight,
    appBarForegroundColor: AppColors.appBarTextLight,
    drawerBackgroundColor: AppColors.drawerBgLight,
    scaffoldBackgroundColor: AppColors.scaffoldBgLight,
    listTileColor: AppColors.cardBgLight,
    iconColor: AppColors.primaryLight,
    fabBackgroundColor: AppColors.appBarBgLight,
    fabForegroundColor: AppColors.appBarTextLight,
    progressColor: AppColors.activeLight,
    popupMenuColor: AppColors.cardBgLight,
    dialogBackgroundColor: AppColors.cardBgLight,
    snackBarBackgroundColor: AppColors.cardBgLight,
    snackBarContentTextColor: AppColors.primaryTextLight,
    dividerColor: AppColors.dividerLight,
  );
}

ThemeData classicTheme(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.light,
    colors: AppThemeColors.classic,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryClassic,
      onPrimary: AppColors.appBarTextClassic,
      primaryContainer: AppColors.highlightClassic,
      secondary: AppColors.secondaryClassic,
      onSecondary: AppColors.appBarTextClassic,
      secondaryContainer: AppColors.cardBgClassic,
      tertiary: AppColors.accentClassic,
      error: AppColors.danger,
      onError: AppColors.appBarTextClassic,
      surface: AppColors.surfaceBgClassic,
      onSurface: AppColors.primaryTextClassic,
      surfaceContainerHighest: AppColors.cardBgClassic,
      onSurfaceVariant: AppColors.secondaryTextClassic,
      inverseSurface: AppColors.primaryTextClassic,
      onInverseSurface: AppColors.appBarTextClassic,
      inversePrimary: AppColors.accentClassic,
      outline: AppColors.secondaryTextClassic,
      outlineVariant: AppColors.dividerClassic,
    ),
    textTheme: _buildLegacyTextTheme(
      headlineColor: AppColors.primaryTextClassic,
      titleColor: AppColors.secondaryTextClassic,
      bodyColor: AppColors.primaryTextClassic,
      labelColor: AppColors.primaryTextClassic,
    ),
    appBarBackgroundColor: AppColors.appBarBgClassic,
    appBarForegroundColor: AppColors.appBarTextClassic,
    drawerBackgroundColor: AppColors.drawerBgClassic,
    scaffoldBackgroundColor: AppColors.scaffoldBgClassic,
    listTileColor: AppColors.cardBgClassic,
    iconColor: AppColors.secondaryClassic,
    fabBackgroundColor: AppColors.appBarBgClassic,
    fabForegroundColor: AppColors.accentClassic,
    progressColor: AppColors.secondaryClassic,
    popupMenuColor: AppColors.cardBgClassic,
    dialogBackgroundColor: AppColors.cardBgClassic,
    snackBarBackgroundColor: AppColors.primaryTextClassic,
    snackBarContentTextColor: AppColors.appBarTextClassic,
    dividerColor: AppColors.dividerClassic,
  );
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
  Color? snackBarContentTextColor,
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
        : DialogThemeData(
            backgroundColor: dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
    snackBarTheme: snackBarBackgroundColor == null
        ? null
        : SnackBarThemeData(
            backgroundColor: snackBarBackgroundColor,
            contentTextStyle: snackBarContentTextColor == null
                ? null
                : TextStyle(color: snackBarContentTextColor),
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
