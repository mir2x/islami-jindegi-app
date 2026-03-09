import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.active,
    required this.selectedItem,
    required this.scaffoldBg,
    required this.appBarBg,
    required this.drawerBg,
    required this.drawerHeaderBg,
    required this.navBarBg,
    required this.cardBg,
    required this.surfaceBg,
    required this.primaryText,
    required this.secondaryText,
    required this.arabicText,
    required this.translationText,
    required this.appBarText,
    required this.activeTabText,
    required this.inactiveTabText,
    required this.highlight,
    required this.highlightBorder,
    required this.selectionOverlay,
    required this.contextMenuBg,
    required this.contextMenuText,
    required this.dropdownBg,
    required this.divider,
    required this.shadow,
    required this.drawerScrim,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color active;
  final Color selectedItem;
  final Color scaffoldBg;
  final Color appBarBg;
  final Color drawerBg;
  final Color drawerHeaderBg;
  final Color navBarBg;
  final Color cardBg;
  final Color surfaceBg;
  final Color primaryText;
  final Color secondaryText;
  final Color arabicText;
  final Color translationText;
  final Color appBarText;
  final Color activeTabText;
  final Color inactiveTabText;
  final Color highlight;
  final Color highlightBorder;
  final Color selectionOverlay;
  final Color contextMenuBg;
  final Color contextMenuText;
  final Color dropdownBg;
  final Color divider;
  final Color shadow;
  final Color drawerScrim;

  static const AppThemeColors light = AppThemeColors(
    primary: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    accent: AppColors.accentLight,
    active: AppColors.activeLight,
    selectedItem: AppColors.selectedItemLight,
    scaffoldBg: AppColors.scaffoldBgLight,
    appBarBg: AppColors.appBarBgLight,
    drawerBg: AppColors.drawerBgLight,
    drawerHeaderBg: AppColors.drawerHeaderBgLight,
    navBarBg: AppColors.navBarBgLight,
    cardBg: AppColors.cardBgLight,
    surfaceBg: AppColors.surfaceBgLight,
    primaryText: AppColors.primaryTextLight,
    secondaryText: AppColors.secondaryTextLight,
    arabicText: AppColors.arabicTextLight,
    translationText: AppColors.translationTextLight,
    appBarText: AppColors.appBarTextLight,
    activeTabText: AppColors.activeTabTextLight,
    inactiveTabText: AppColors.inactiveTabTextLight,
    highlight: AppColors.highlightLight,
    highlightBorder: AppColors.highlightBorderLight,
    selectionOverlay: AppColors.selectionOverlayLight,
    contextMenuBg: AppColors.contextMenuBgLight,
    contextMenuText: AppColors.contextMenuTextLight,
    dropdownBg: AppColors.dropdownBgLight,
    divider: AppColors.dividerLight,
    shadow: AppColors.shadowLight,
    drawerScrim: AppColors.drawerScrimLight,
  );

  static final AppThemeColors lightNew = AppThemeColors.light.copyWith(
    appBarBg: AppColors.surfaceBgLight,
  );

  // ── Dark Theme ───────────────────────
  static const AppThemeColors dark = AppThemeColors(
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
    accent: AppColors.accentDark,
    active: AppColors.activeDark,
    selectedItem: AppColors.selectedItemDark,
    scaffoldBg: AppColors.scaffoldBgDark,
    appBarBg: AppColors.appBarBgDark,
    drawerBg: AppColors.drawerBgDark,
    drawerHeaderBg: AppColors.drawerHeaderBgDark,
    navBarBg: AppColors.navBarBgDark,
    cardBg: AppColors.cardBgDark,
    surfaceBg: AppColors.surfaceBgDark,
    primaryText: AppColors.primaryTextDark,
    secondaryText: AppColors.secondaryTextDark,
    arabicText: AppColors.arabicTextDark,
    translationText: AppColors.translationTextDark,
    appBarText: AppColors.appBarTextDark,
    activeTabText: AppColors.activeTabTextDark,
    inactiveTabText: AppColors.inactiveTabTextDark,
    highlight: AppColors.highlightDark,
    highlightBorder: AppColors.highlightBorderDark,
    selectionOverlay: AppColors.selectionOverlayDark,
    contextMenuBg: AppColors.contextMenuBgDark,
    contextMenuText: AppColors.contextMenuTextDark,
    dropdownBg: AppColors.dropdownBgDark,
    divider: AppColors.dividerDark,
    shadow: AppColors.shadowDark,
    drawerScrim: AppColors.drawerScrimDark,
  );

  // ── Lerp (for animations) ───────────────
  @override
  AppThemeColors lerp(AppThemeColors? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      active: Color.lerp(active, other.active, t)!,
      selectedItem: Color.lerp(selectedItem, other.selectedItem, t)!,
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      appBarBg: Color.lerp(appBarBg, other.appBarBg, t)!,
      drawerBg: Color.lerp(drawerBg, other.drawerBg, t)!,
      drawerHeaderBg: Color.lerp(drawerHeaderBg, other.drawerHeaderBg, t)!,
      navBarBg: Color.lerp(navBarBg, other.navBarBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      surfaceBg: Color.lerp(surfaceBg, other.surfaceBg, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      arabicText: Color.lerp(arabicText, other.arabicText, t)!,
      translationText: Color.lerp(translationText, other.translationText, t)!,
      appBarText: Color.lerp(appBarText, other.appBarText, t)!,
      activeTabText: Color.lerp(activeTabText, other.activeTabText, t)!,
      inactiveTabText: Color.lerp(inactiveTabText, other.inactiveTabText, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      highlightBorder: Color.lerp(highlightBorder, other.highlightBorder, t)!,
      selectionOverlay:
          Color.lerp(selectionOverlay, other.selectionOverlay, t)!,
      contextMenuBg: Color.lerp(contextMenuBg, other.contextMenuBg, t)!,
      contextMenuText: Color.lerp(contextMenuText, other.contextMenuText, t)!,
      dropdownBg: Color.lerp(dropdownBg, other.dropdownBg, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      drawerScrim: Color.lerp(drawerScrim, other.drawerScrim, t)!,
    );
  }

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? active,
    Color? selectedItem,
    Color? scaffoldBg,
    Color? appBarBg,
    Color? drawerBg,
    Color? drawerHeaderBg,
    Color? navBarBg,
    Color? cardBg,
    Color? surfaceBg,
    Color? primaryText,
    Color? secondaryText,
    Color? arabicText,
    Color? translationText,
    Color? appBarText,
    Color? activeTabText,
    Color? inactiveTabText,
    Color? highlight,
    Color? highlightBorder,
    Color? selectionOverlay,
    Color? contextMenuBg,
    Color? contextMenuText,
    Color? dropdownBg,
    Color? divider,
    Color? shadow,
    Color? drawerScrim,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      active: active ?? this.active,
      selectedItem: selectedItem ?? this.selectedItem,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      appBarBg: appBarBg ?? this.appBarBg,
      drawerBg: drawerBg ?? this.drawerBg,
      drawerHeaderBg: drawerHeaderBg ?? this.drawerHeaderBg,
      navBarBg: navBarBg ?? this.navBarBg,
      cardBg: cardBg ?? this.cardBg,
      surfaceBg: surfaceBg ?? this.surfaceBg,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      arabicText: arabicText ?? this.arabicText,
      translationText: translationText ?? this.translationText,
      appBarText: appBarText ?? this.appBarText,
      activeTabText: activeTabText ?? this.activeTabText,
      inactiveTabText: inactiveTabText ?? this.inactiveTabText,
      highlight: highlight ?? this.highlight,
      highlightBorder: highlightBorder ?? this.highlightBorder,
      selectionOverlay: selectionOverlay ?? this.selectionOverlay,
      contextMenuBg: contextMenuBg ?? this.contextMenuBg,
      contextMenuText: contextMenuText ?? this.contextMenuText,
      dropdownBg: dropdownBg ?? this.dropdownBg,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
      drawerScrim: drawerScrim ?? this.drawerScrim,
    );
  }
}
