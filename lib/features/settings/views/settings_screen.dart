import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  static const List<Map<String, String>> languages = [
    {'value': 'bn'},
    {'value': 'en'},
  ];

  static const List<Map<String, String>> banglaFonts = [
    {'label': 'Solaiman Lipi', 'value': 'bangla/solaimanlipi'},
    {'label': 'Siyam Rupali', 'value': 'bangla/siyamrupali'},
    {'label': 'Kalpurush', 'value': 'bangla/kalpurush'},
    {'label': 'Noto Sans Bengali', 'value': 'bangla/noto-sans-bengali'},
    {'label': 'Ben Sen Handwriting', 'value': 'bangla/ben-sen-handwriting'},
  ];

  static const List<Map<String, String>> arabicFonts = [
    {
      'label': 'Noorehuda (Default)',
      'value': 'arabic/noorehuda',
    },
    {
      'label': 'Al Qalam Quran Majeed',
      'value': 'arabic/al-qalam-quran-majeed',
    },
    {
      'label': 'Al Qalam Kolkatta Quran Majeed',
      'value': 'arabic/al-qalam-kolkatta',
    },
    {
      'label': 'Al Mushaf Quran',
      'value': 'arabic/al-mushaf',
    },
    {
      'label': 'Al Qalam Quran',
      'value': 'arabic/al-qalam-quran',
    },
    {
      'label': 'Uthman',
      'value': 'arabic/Uthman',
    },
    {
      'label': 'Uthmani',
      'value': 'arabic/Uthmani',
    },
    {
      'label': 'Me-Quran',
      'value': 'arabic/Me-Quran',
    },
    {
      'label': 'Kitab',
      'value': 'arabic/Kitab',
    },
  ];

  static const List<Map<String, String>> themes = [
    {'value': 'classic'},
    {'value': 'light'},
    {'value': 'dark'},
  ];

  static const List<Map<String, String>> backgrounds = [
    {'value': 'mosque'},
    {'value': 'no-background'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final prefs = ref.watch(preferencesProvider);

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      title: Text(locales.settings),
      body: prefs.when(
        loading: () => const FullScreenLoader(),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (preferences) {
          final selectedHijriAdj = preferences.getInt('hijriLocalAdjustment');
          final selectedLocale = _selectedValue(
            items: languages,
            value: preferences.getString('locale'),
            fallback: 'bn',
          );
          final selectedArabicFont = _selectedValue(
            items: arabicFonts,
            value: preferences.getString('arabicFont'),
            fallback: 'arabic/noorehuda',
          );
          final selectedBanglaFont = _selectedValue(
            items: banglaFonts,
            value: preferences.getString('banglaFont'),
            fallback: 'bangla/solaimanlipi',
          );
          final selectedTheme = _selectedValue(
            items: themes,
            value: preferences.getString('theme'),
            fallback: 'classic',
          );
          final selectedBackground = _selectedValue(
            items: backgrounds,
            value: preferences.getString('background'),
            fallback: 'mosque',
          );
          final selectedDaylight = preferences.getBool('daylight') ?? false;
          final effectiveHijriAdj = selectedHijriAdj ?? 0;

          return ItemContent(
            children: [
              _SectionLabel(label: locales.hijriDateAdjustment),
              const SizedBox(height: 10),
              _HijriAdjustmentStrip(
                selectedValue: effectiveHijriAdj,
                onSelected: (value) {
                  if (effectiveHijriAdj == value) {
                    ref
                        .read(preferencesProvider.notifier)
                        .removeHijriLocalAdjustment();
                    return;
                  }
                  ref
                      .read(preferencesProvider.notifier)
                      .updateHijriLocalAdjustment(value);
                },
              ),
              const SizedBox(height: 18),
              _SettingsGroupCard(
                children: [
                  _SettingsSwitchRow(
                    title: locales.daylightSaving,
                    subtitle: locales.onlyUsedToCalculatePrayerTimes,
                    value: selectedDaylight,
                    onChanged: (value) {
                      ref
                          .read(preferencesProvider.notifier)
                          .updateDaylight(value);
                    },
                  ),
                  _SettingsValueRow(
                    title: locales.language,
                    value: _localizedSettingLabel(
                      context,
                      selectedLocale,
                    ),
                    onTap: () async {
                      await _showSelectionSheet<String>(
                        context: context,
                        title: locales.language,
                        items: languages,
                        selectedValue: selectedLocale,
                        labelBuilder: (value) =>
                            _localizedSettingLabel(context, value),
                        onSelected: (value) {
                          ref
                              .read(preferencesProvider.notifier)
                              .updateLocale(value);
                        },
                      );
                    },
                  ),
                  _SettingsValueRow(
                    title: locales.arabicFont,
                    value: _labelForValue(arabicFonts, selectedArabicFont),
                    onTap: () async {
                      await _showSelectionSheet<String>(
                        context: context,
                        title: locales.arabicFont,
                        items: arabicFonts,
                        selectedValue: selectedArabicFont,
                        labelBuilder: (value) =>
                            _labelForValue(arabicFonts, value),
                        onSelected: (value) {
                          ref
                              .read(preferencesProvider.notifier)
                              .updateArabicFont(value);
                        },
                      );
                    },
                  ),
                  _SettingsValueRow(
                    title: locales.banglaFont,
                    value: _labelForValue(banglaFonts, selectedBanglaFont),
                    onTap: () async {
                      await _showSelectionSheet<String>(
                        context: context,
                        title: locales.banglaFont,
                        items: banglaFonts,
                        selectedValue: selectedBanglaFont,
                        labelBuilder: (value) =>
                            _labelForValue(banglaFonts, value),
                        onSelected: (value) {
                          ref
                              .read(preferencesProvider.notifier)
                              .updateBanglaFont(value);
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SettingsGroupCard(
                children: [
                  _SettingsValueRow(
                    title: locales.theme,
                    value: _localizedSettingLabel(context, selectedTheme),
                    onTap: () async {
                      await _showSelectionSheet<String>(
                        context: context,
                        title: locales.theme,
                        items: themes,
                        selectedValue: selectedTheme,
                        labelBuilder: (value) =>
                            _localizedSettingLabel(context, value),
                        onSelected: (value) {
                          ref
                              .read(preferencesProvider.notifier)
                              .updateTheme(value);
                        },
                      );
                    },
                  ),
                  _SettingsValueRow(
                    title: locales.background,
                    value: _localizedSettingLabel(
                      context,
                      selectedBackground,
                    ),
                    valuePrefix: _BackgroundValuePreview(
                      backgroundValue: selectedBackground,
                    ),
                    onTap: () async {
                      await _showSelectionSheet<String>(
                        context: context,
                        title: locales.background,
                        items: backgrounds,
                        selectedValue: selectedBackground,
                        labelBuilder: (value) =>
                            _localizedSettingLabel(context, value),
                        onSelected: (value) {
                          ref
                              .read(preferencesProvider.notifier)
                              .updateBackground(value);
                        },
                        previewBuilder: (value) =>
                            _BackgroundValuePreview(backgroundValue: value),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static String _selectedValue({
    required List<Map<String, String>> items,
    required String? value,
    required String fallback,
  }) {
    return items.map((item) => item['value']).firstWhereOrNull((item) {
          return item == value;
        }) ??
        fallback;
  }

  static String _labelForValue(
    List<Map<String, String>> items,
    String selectedValue,
  ) {
    return items.firstWhere(
          (item) => item['value'] == selectedValue,
          orElse: () => items.first,
        )['label'] ??
        '';
  }

  static String _localizedSettingLabel(BuildContext context, String value) {
    final locales = AppLocalizations.of(context)!;

    return switch (value) {
      'bn' => locales.bangla,
      'en' => locales.english,
      'classic' => locales.classic,
      'light' => locales.light,
      'dark' => locales.dark,
      'pattern' => locales.pattern,
      'mosque' => locales.mosqueBackground,
      'no-background' => locales.noBackground,
      _ => value,
    };
  }
}

Future<void> _showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required List<Map<String, dynamic>> items,
  required T selectedValue,
  required ValueChanged<T> onSelected,
  required String Function(T value) labelBuilder,
  Widget Function(T value)? previewBuilder,
}) async {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  final textTheme = Theme.of(context).textTheme;
  final isClassic = colors.primary == AppThemeColors.classic.primary &&
      colors.appBarBg == AppThemeColors.classic.appBarBg;
  final selectedAccent = isClassic ? colors.appBarBg : colors.primary;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: items.map((item) {
                      final value = item['value'] as T;
                      final isSelected = value == selectedValue;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            onSelected(value);
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withValues(alpha: 0.1)
                                  : colors.surfaceBg.withValues(alpha: 0.78),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? colors.primary
                                    : colors.divider.withValues(alpha: 0.42),
                                width: isSelected ? 1.4 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (previewBuilder != null) ...[
                                  previewBuilder(value),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: Text(
                                    labelBuilder(value),
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.primaryText,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.chevron_right_rounded,
                                  color: isSelected
                                      ? selectedAccent
                                      : colors.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
      ),
    );
  }
}

class _HijriAdjustmentStrip extends StatelessWidget {
  const _HijriAdjustmentStrip({
    required this.selectedValue,
    required this.onSelected,
  });

  final int selectedValue;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final accentColor = isClassic ? colors.appBarBg : colors.primary;
    final accentBrightness = ThemeData.estimateBrightnessForColor(accentColor);
    final accentForeground = accentBrightness == Brightness.dark
        ? colors.appBarText
        : colors.primaryText;
    const options = [-2, -1, 0, 1, 2];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.divider.withValues(alpha: 0.42)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: options.map((value) {
          final isSelected = value == selectedValue;
          final label = value > 0 ? '+$value' : '$value';
          return GestureDetector(
            onTap: () => onSelected(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? accentColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color:
                          isSelected ? accentForeground : colors.secondaryText,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final rows = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          Divider(
            height: 1,
            thickness: 1,
            color: colors.surfaceBg.withValues(alpha: 0.92),
          ),
        );
      }
      rows.add(children[i]);
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.divider.withValues(alpha: 0.42)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: rows),
    );
  }
}

class _SettingsValueRow extends StatelessWidget {
  const _SettingsValueRow({
    required this.title,
    required this.value,
    required this.onTap,
    this.valuePrefix,
  });

  final String title;
  final String value;
  final VoidCallback onTap;
  final Widget? valuePrefix;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final trailingWidth = math.min(
      MediaQuery.sizeOf(context).width * 0.44,
      190.0,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.primaryText,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: trailingWidth,
              child: Row(
                children: [
                  if (valuePrefix != null) ...[
                    valuePrefix!,
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isClassic ? colors.appBarBg : colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.secondaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.secondaryText,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _BackgroundValuePreview extends StatelessWidget {
  const _BackgroundValuePreview({
    required this.backgroundValue,
  });

  final String backgroundValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final icon = switch (backgroundValue) {
      'pattern' => Icons.grid_4x4_rounded,
      'no-background' => Icons.hide_image_rounded,
      _ => Icons.account_balance_rounded,
    };

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: colors.surfaceBg.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.divider.withValues(alpha: 0.42)),
      ),
      child: Icon(
        icon,
        size: 16,
        color: isClassic ? colors.appBarBg : colors.primary,
      ),
    );
  }
}
