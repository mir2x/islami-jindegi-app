import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_color.dart';
import 'colors.dart';

ThemeData darkTheme(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.dark,
    colors: AppThemeColors.legacyDark,
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
    textTheme: _buildLegacyTextTheme(
      headlineColor: ThemeColors.color3,
      titleColor: ThemeColors.color4,
      bodyColor: ThemeColors.color3,
      labelColor: ThemeColors.color3,
    ),
    appBarBackgroundColor: ThemeColors.color5,
    appBarForegroundColor: ThemeColors.color3,
    drawerBackgroundColor: ThemeColors.color5,
    listTileColor: ThemeColors.color7,
    iconColor: ThemeColors.color4,
    fabBackgroundColor: ThemeColors.color5,
    fabForegroundColor: ThemeColors.color4,
    progressColor: ThemeColors.color4,
    popupMenuColor: ThemeColors.color5,
    dialogBackgroundColor: ThemeColors.color1,
    selectionColor: ThemeColors.color8,
    selectionHandleColor: ThemeColors.color8,
  );
}

ThemeData lightTheme(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.light,
    colors: AppThemeColors.legacyLight,
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
    textTheme: _buildLegacyTextTheme(
      headlineColor: ThemeColors.color2,
      titleColor: ThemeColors.color8,
      bodyColor: ThemeColors.color2,
      labelColor: ThemeColors.color2,
    ),
    appBarBackgroundColor: ThemeColors.color3,
    appBarForegroundColor: ThemeColors.color8,
    drawerBackgroundColor: ThemeColors.color3,
    listTileColor: ThemeColors.color3,
    iconColor: ThemeColors.color8,
    fabBackgroundColor: ThemeColors.color3,
    fabForegroundColor: ThemeColors.color4,
    progressColor: ThemeColors.color8,
    popupMenuColor: ThemeColors.color3,
    dialogBackgroundColor: ThemeColors.color3,
    snackBarBackgroundColor: ThemeColors.color6,
    selectionColor: ThemeColors.color4,
    selectionHandleColor: ThemeColors.color4,
  );
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
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.light,
    colors: AppThemeColors.lightNew,
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
    textTheme: _buildNewTextTheme(
      primaryTextColor: AppColors.primaryTextLight,
      secondaryTextColor: AppColors.secondaryTextLight,
    ),
    appBarBackgroundColor: AppColors.appBarBgLight,
    appBarForegroundColor: AppColors.appBarTextLight,
    drawerBackgroundColor: AppColors.drawerBgLight,
    popupMenuColor: AppColors.dropdownBgLight,
    dividerColor: AppColors.dividerLight,
  );
}

ThemeData darkThemeNew(Map fonts) {
  return _buildTheme(
    fonts: fonts,
    brightness: Brightness.dark,
    colors: AppThemeColors.darkNew,
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
    textTheme: _buildNewTextTheme(
      primaryTextColor: AppColors.primaryTextDark,
      secondaryTextColor: AppColors.secondaryTextDark,
    ),
    appBarBackgroundColor: AppColors.appBarBgDark,
    appBarForegroundColor: AppColors.appBarTextDark,
    drawerBackgroundColor: AppColors.drawerBgDark,
    popupMenuColor: AppColors.dropdownBgDark,
    dividerColor: AppColors.dividerDark,
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
    textSelectionTheme:
        selectionColor == null || selectionHandleColor == null
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

TextTheme _buildNewTextTheme({
  required Color primaryTextColor,
  required Color secondaryTextColor,
}) {
  return TextTheme(
    bodyLarge: TextStyle(color: primaryTextColor),
    bodyMedium: TextStyle(color: primaryTextColor),
    bodySmall: TextStyle(color: secondaryTextColor),
    titleLarge: TextStyle(color: primaryTextColor),
    titleMedium: TextStyle(color: primaryTextColor),
    titleSmall: TextStyle(color: secondaryTextColor),
    labelLarge: TextStyle(color: primaryTextColor),
    labelMedium: TextStyle(color: secondaryTextColor),
    labelSmall: TextStyle(color: secondaryTextColor),
  );
}
