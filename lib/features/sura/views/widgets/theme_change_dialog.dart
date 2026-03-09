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
    {'label': 'ডার্ক', 'value': 'dark'},
    {'label': 'লাইট', 'value': 'light'},
    {'label': 'ক্লাসিক', 'value': 'classic'},
    {'label': 'ডার্ক নিউ', 'value': 'darkNew'},
    {'label': 'লাইট নিউ', 'value': 'lightNew'},
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
    final isLight =
        Theme.of(context).colorScheme.brightness == Brightness.light;
    final accent =
        isLight ? colors.secondaryText : Theme.of(context).colorScheme.primary;
    final actionBg = isLight
        ? colors.surfaceBg.withOpacity(0.9)
        : Theme.of(context).colorScheme.primary;

    return AlertDialog(
      title: const Text('থিম পরিবর্তন'),
      content: DropdownButtonFormField<String>(
        value: _selectedTheme,
        items: _themes
            .map((theme) => DropdownMenuItem<String>(
                  value: theme['value'],
                  child: Text(theme['label']!),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedTheme = value);
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: accent),
          child: const Text('বাতিল'),
        ),
        FilledButton(
          onPressed: _onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: actionBg,
            foregroundColor: isLight ? colors.secondaryText : colors.surfaceBg,
          ),
          child: const Text('সংরক্ষণ'),
        ),
      ],
    );
  }
}
