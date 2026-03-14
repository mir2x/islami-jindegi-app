import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ThemeChangeDialog extends ConsumerStatefulWidget {
  const ThemeChangeDialog({super.key});

  @override
  ConsumerState<ThemeChangeDialog> createState() => _ThemeChangeDialogState();
}

class _ThemeChangeDialogState extends ConsumerState<ThemeChangeDialog> {
  String _selectedTheme = 'classic';

  static const List<Map<String, String>> _themes = [
    {'label': 'ক্লাসিক', 'value': 'classic'},
  ];

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(preferencesProvider).valueOrNull;
    final currentTheme = prefs?.getString('theme') ?? 'classic';
    if (_themes.any((theme) => theme['value'] == currentTheme)) {
      _selectedTheme = currentTheme;
    }
  }

  Future<void> _onConfirm() async {
    await ref.read(preferencesProvider.notifier).updateTheme(_selectedTheme);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return AlertDialog(
      backgroundColor: colors.cardBg,
      surfaceTintColor: colors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.divider),
      ),
      title: Text(
        'থিম পরিবর্তন',
        style: TextStyle(color: colors.primaryText),
      ),
      content: DropdownButtonFormField<String>(
        dropdownColor: colors.dropdownBg,
        value: _selectedTheme,
        items: _themes
            .map(
              (theme) => DropdownMenuItem<String>(
                value: theme['value'],
                child: Text(theme['label']!),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedTheme = value);
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.active),
          ),
          fillColor: colors.dropdownBg,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: colors.active),
          child: const Text('বাতিল'),
        ),
        FilledButton(
          onPressed: _onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: colors.active,
            foregroundColor: colors.appBarText,
          ),
          child: const Text('সংরক্ষণ'),
        ),
      ],
    );
  }
}
