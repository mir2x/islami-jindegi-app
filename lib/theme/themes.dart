import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: ThemeColors().themeColor3,
      fontSize: 24,
    ),
    headlineMedium: TextStyle(
      color: ThemeColors().themeColor3,
      fontSize: 20,
    ),
    titleLarge: TextStyle(
      color: ThemeColors().themeColor4,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: ThemeColors().themeColor4,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: ThemeColors().themeColor3,
      fontSize: 16,
    ),
    labelLarge: TextStyle(
      color: ThemeColors().themeColor3,
      fontSize: 18,
    ),
    labelMedium: TextStyle(
      color: ThemeColors().themeColor3,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: ThemeColors().themeColor3,
      fontSize: 13,
      letterSpacing: 1,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColors().themeColor5,
  ),
  iconTheme: IconThemeData(
    color: ThemeColors().themeColor4,
  ),
);
