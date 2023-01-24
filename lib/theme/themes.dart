import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme = ThemeData(
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: ThemeColors.color3,
      fontSize: 24,
    ),
    headlineMedium: TextStyle(
      color: ThemeColors.color3,
      fontSize: 20,
    ),
    titleLarge: TextStyle(
      color: ThemeColors.color4,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: ThemeColors.color4,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: ThemeColors.color3,
      fontSize: 16,
    ),
    labelLarge: TextStyle(
      color: ThemeColors.color3,
      fontSize: 18,
    ),
    labelMedium: TextStyle(
      color: ThemeColors.color3,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: ThemeColors.color3,
      fontSize: 13,
      letterSpacing: 0.9,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.color5,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: ThemeColors.color5,
  ),
  iconTheme: const IconThemeData(
    color: ThemeColors.color4,
  ),
);
