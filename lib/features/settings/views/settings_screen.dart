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
    {'label': 'Bangla', 'value': 'bn'},
    {'label': 'English', 'value': 'en'},
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
    {'label': 'Classic', 'value': 'classic'},
    {'label': 'Light', 'value': 'light'},
    {'label': 'Dark', 'value': 'dark'},
  ];

  static const List<Map<String, String>> backgrounds = [
    {'label': 'Pattern', 'value': 'pattern'},
    {'label': 'Mosque', 'value': 'mosque'},
    {'label': 'No Background', 'value': 'no-background'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final prefs = ref.watch(preferencesProvider);

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
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

          return ItemContent(
            children: [
              _SettingsHero(
                language: _labelForValue(languages, selectedLocale),
                theme: _labelForValue(themes, selectedTheme),
                background: _labelForValue(backgrounds, selectedBackground),
              ),
              const SizedBox(height: 20),
              _SettingsCard(
                title: locales.theme,
                subtitle: 'Refresh the app look with cleaner display options.',
                child: Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: themes.map((theme) {
                        return _ThemeChoiceCard(
                          label: theme['label']!,
                          isSelected: theme['value'] == selectedTheme,
                          onTap: () {
                            ref
                                .read(preferencesProvider.notifier)
                                .updateTheme(theme['value']);
                          },
                        );
                      }).toList(),
                    ),
                    if (selectedTheme == 'classic') ...[
                      const SizedBox(height: 18),
                      _SegmentedSelector(
                        title: locales.background,
                        icon: Icons.layers_rounded,
                        items: backgrounds,
                        selectedValue: selectedBackground,
                        onSelected: (value) {
                          ref
                              .read(preferencesProvider.notifier)
                              .updateBackground(value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SettingsCard(
                title: locales.language,
                subtitle: 'Control language and typography in one place.',
                child: Column(
                  children: [
                    _SegmentedSelector(
                      title: locales.language,
                      icon: Icons.language_rounded,
                      items: languages,
                      selectedValue: selectedLocale,
                      onSelected: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateLocale(value);
                      },
                    ),
                    const SizedBox(height: 14),
                    _DropdownTile(
                      icon: Icons.auto_stories_rounded,
                      label: locales.arabicFont,
                      value: selectedArabicFont,
                      items: arabicFonts,
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(preferencesProvider.notifier)
                            .updateArabicFont(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    _DropdownTile(
                      icon: Icons.translate_rounded,
                      label: locales.banglaFont,
                      value: selectedBanglaFont,
                      items: banglaFonts,
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(preferencesProvider.notifier)
                            .updateBanglaFont(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SettingsCard(
                title: locales.hijriDateAdjustment,
                subtitle: locales.onlyUsedToCalculatePrayerTimes,
                child: Column(
                  children: [
                    _SegmentedSelector<int>(
                      title: locales.hijriDateAdjustment,
                      icon: Icons.calendar_month_rounded,
                      items: const [
                        {'label': '-2', 'value': -2},
                        {'label': '-1', 'value': -1},
                        {'label': '0', 'value': 0},
                        {'label': '+1', 'value': 1},
                        {'label': '+2', 'value': 2},
                      ],
                      selectedValue: selectedHijriAdj,
                      onSelected: (value) {
                        if (selectedHijriAdj == value) {
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
                    _SwitchTile(
                      icon: Icons.wb_twilight_rounded,
                      title: locales.daylightSaving,
                      subtitle: locales.onlyUsedToCalculatePrayerTimes,
                      value: selectedDaylight,
                      onChanged: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateDaylight(value);
                      },
                    ),
                  ],
                ),
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
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero({
    required this.language,
    required this.theme,
    required this.background,
  });

  final String language;
  final String theme;
  final String background;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final heroTextColor = colors.surfaceBg;
    final heroChipColor = colors.surfaceBg.withValues(alpha: 0.16);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.92),
            colors.secondary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: heroChipColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune_rounded, color: heroTextColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Personalize your app',
                  style: TextStyle(
                    color: heroTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Make reading, prayer time, and browsing feel more yours.',
            style: textTheme.headlineSmall?.copyWith(
              color: heroTextColor,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroChip(icon: Icons.language_rounded, label: language),
              _HeroChip(icon: Icons.palette_rounded, label: theme),
              _HeroChip(icon: Icons.image_rounded, label: background),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceBg.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.surfaceBg, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: colors.surfaceBg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.divider.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.secondaryText,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ThemeChoiceCard extends StatelessWidget {
  const _ThemeChoiceCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final width = (MediaQuery.of(context).size.width - 72) / 2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width < 150 ? double.infinity : width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.divider.withValues(alpha: 0.45),
            width: isSelected ? 1.6 : 1,
          ),
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.surfaceBg.withValues(alpha: 0.72),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? colors.primary : colors.secondaryText,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _PaletteDot(color: colors.primary),
                const SizedBox(width: 8),
                _PaletteDot(color: colors.secondary),
                const SizedBox(width: 8),
                _PaletteDot(color: colors.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteDot extends StatelessWidget {
  const _PaletteDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SegmentedSelector<T> extends StatelessWidget {
  const _SegmentedSelector({
    required this.title,
    required this.icon,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final IconData icon;
  final List<Map<String, dynamic>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((item) {
            final bool isSelected = item['value'] == selectedValue;
            return ChoiceChip(
              label: Text(item['label'].toString()),
              selected: isSelected,
              showCheckmark: false,
              labelStyle: textTheme.labelLarge?.copyWith(
                color: isSelected ? colors.appBarText : colors.primaryText,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: colors.surfaceBg.withValues(alpha: 0.7),
              selectedColor: colors.primary,
              side: BorderSide(
                color: isSelected
                    ? colors.primary
                    : colors.divider.withValues(alpha: 0.45),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (_) => onSelected(item['value'] as T),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DropdownTile extends StatelessWidget {
  const _DropdownTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String value;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceBg.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.divider.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: value,
                    borderRadius: BorderRadius.circular(18),
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                    dropdownColor: colors.dropdownBg,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colors.secondaryText,
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['label']!),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceBg.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.divider.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.secondaryText,
                    height: 1.4,
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
