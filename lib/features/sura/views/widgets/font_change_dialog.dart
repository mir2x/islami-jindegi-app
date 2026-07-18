import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../providers/font_settings_providers.dart';

class FontChangeDialog extends ConsumerStatefulWidget {
  const FontChangeDialog({super.key});

  @override
  ConsumerState<FontChangeDialog> createState() => _FontChangeDialogState();
}

class _FontChangeDialogState extends ConsumerState<FontChangeDialog> {
  late String _selectedLanguage;
  late String _selectedArabicFont;
  late String _selectedBengaliFont;
  late double _selectedArabicSize;
  late double _selectedBengaliSize;

  final List<String> _languages = ['Arabic', 'Bengali'];
  final List<String> _arabicFonts = [
    'Noorehuda (Default)',
    'Al Mushaf Quran',
    'Al Qalam Kolkatta Quranic',
    'Al Qalam Quran',
    'Al Qalam Quran Majeed',
    'Uthman',
    'Uthmani',
    'Me-Quran',
    'Kitab',
  ];
  final List<String> _bengaliFonts = [
    'SolaimanLipi',
    'Kalpurush',
    'Noto Sans Bengali',
    'Siyam Rupali',
    'Ben Sen Handwriting',
  ];
  final Map<String, String> _arabicFontMap = {
    'Noorehuda (Default)': 'arabic/noorehuda',
    'Al Mushaf Quran': 'arabic/al-mushaf',
    'Al Qalam Kolkatta Quranic': 'arabic/al-qalam-kolkatta',
    'Al Qalam Quran': 'arabic/al-qalam-quran',
    'Al Qalam Quran Majeed': 'arabic/al-qalam-quran-majeed',
    'Uthman': 'arabic/Uthman',
    'Uthmani': 'arabic/Uthmani',
    'Me-Quran': 'arabic/Me-Quran',
    'Kitab': 'arabic/Kitab',
  };

  final Map<String, String> _bengaliFontMap = {
    'SolaimanLipi': 'bangla/solaimanlipi',
    'Kalpurush': 'bangla/kalpurush',
    'Noto Sans Bengali': 'bangla/noto-sans-bengali',
    'Siyam Rupali': 'bangla/siyamrupali',
    'Ben Sen Handwriting': 'bangla/ben-sen-handwriting',
  };

  final List<double> _fontSizes =
      List.generate(16, (index) => 24.0 + (index * 2));

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _languages.first;

    final arabicFamily = ref.read(arabicFontProvider);
    _selectedArabicFont = _arabicFontMap.entries
        .firstWhere((e) => e.value == arabicFamily,
            orElse: () => _arabicFontMap.entries.first)
        .key;

    final bengaliFamily = ref.read(bengaliFontProvider);
    _selectedBengaliFont = _bengaliFontMap.entries
        .firstWhere((e) => e.value == bengaliFamily,
            orElse: () => _bengaliFontMap.entries.first)
        .key;

    _selectedArabicSize = ref.read(arabicFontSizeProvider);
    _selectedBengaliSize = ref.read(bengaliFontSizeProvider);

    // Clamp to valid range
    if (!_fontSizes.contains(_selectedArabicSize)) {
      _selectedArabicSize = _fontSizes.reduce((a, b) =>
          (a - _selectedArabicSize).abs() < (b - _selectedArabicSize).abs()
              ? a
              : b);
    }
    if (!_fontSizes.contains(_selectedBengaliSize)) {
      _selectedBengaliSize = _fontSizes.reduce((a, b) =>
          (a - _selectedBengaliSize).abs() < (b - _selectedBengaliSize).abs()
              ? a
              : b);
    }
  }

  void _onConfirm() {
    ref
        .read(arabicFontProvider.notifier)
        .setFont(_arabicFontMap[_selectedArabicFont]!);
    ref
        .read(bengaliFontProvider.notifier)
        .setFont(_bengaliFontMap[_selectedBengaliFont]!);
    ref.read(arabicFontSizeProvider.notifier).setSize(_selectedArabicSize);
    ref.read(bengaliFontSizeProvider.notifier).setSize(_selectedBengaliSize);
    Navigator.of(context).pop();
  }

  void _incrementSize(bool isArabic) {
    setState(() {
      if (isArabic) {
        final idx = _fontSizes.indexOf(_selectedArabicSize);
        if (idx < _fontSizes.length - 1)
          _selectedArabicSize = _fontSizes[idx + 1];
      } else {
        final idx = _fontSizes.indexOf(_selectedBengaliSize);
        if (idx < _fontSizes.length - 1)
          _selectedBengaliSize = _fontSizes[idx + 1];
      }
    });
  }

  void _decrementSize(bool isArabic) {
    setState(() {
      if (isArabic) {
        final idx = _fontSizes.indexOf(_selectedArabicSize);
        if (idx > 0) _selectedArabicSize = _fontSizes[idx - 1];
      } else {
        final idx = _fontSizes.indexOf(_selectedBengaliSize);
        if (idx > 0) _selectedBengaliSize = _fontSizes[idx - 1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final bool isArabic = _selectedLanguage == 'Arabic';
    final List<String> currentFonts = isArabic ? _arabicFonts : _bengaliFonts;
    String currentFontSelection =
        isArabic ? _selectedArabicFont : _selectedBengaliFont;
    double currentSizeSelection =
        isArabic ? _selectedArabicSize : _selectedBengaliSize;

    if (!currentFonts.contains(currentFontSelection)) {
      currentFontSelection = currentFonts.first;
    }
    if (!_fontSizes.contains(currentSizeSelection)) {
      currentSizeSelection = _fontSizes.first;
    }

    return AlertDialog(
      backgroundColor: colors.cardBg,
      surfaceTintColor: colors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.divider),
      ),
      title: Text(
        'ফন্ট পরিবর্তন',
        style: TextStyle(color: colors.primaryText),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown<String>(
              label: 'ভাষা',
              value: _selectedLanguage,
              items: _languages,
              onChanged: (value) {
                if (value != null) setState(() => _selectedLanguage = value);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown<String>(
              label: 'ফন্ট',
              value: currentFontSelection,
              items: currentFonts,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    if (isArabic) {
                      _selectedArabicFont = value;
                    } else {
                      _selectedBengaliFont = value;
                    }
                  });
                }
              },
              itemBuilder: (font) {
                final family =
                    isArabic ? _arabicFontMap[font] : _bengaliFontMap[font];
                return Text(font, style: TextStyle(fontFamily: family));
              },
            ),
            const SizedBox(height: 16),
            Text('সাইজ',
                style: const TextStyle(
                    wordSpacing: 3, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () => _decrementSize(isArabic),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: colors.active,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: DropdownButtonFormField<double>(
                    initialValue: currentSizeSelection,
                    items: _fontSizes.map((size) {
                      return DropdownMenuItem<double>(
                        value: size,
                        child: Text(
                          size.toInt().toString(),
                          style: const TextStyle(fontFamily: 'Roboto'),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          if (isArabic) {
                            _selectedArabicSize = value;
                          } else {
                            _selectedBengaliSize = value;
                          }
                        });
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _incrementSize(isArabic),
                  icon: const Icon(Icons.add_circle_outline),
                  color: colors.active,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: colors.active),
          child: const Text('বাতিল', style: TextStyle()),
        ),
        FilledButton(
          onPressed: _onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: colors.active,
            foregroundColor: colors.appBarText,
          ),
          child: const Text('নিশ্চিত করুন', style: TextStyle()),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    Widget Function(T)? itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          dropdownColor:
              Theme.of(context).extension<AppThemeColors>()!.dropdownBg,
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder != null
                  ? itemBuilder(item)
                  : Text(item.toString()),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).extension<AppThemeColors>()!.divider,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).extension<AppThemeColors>()!.divider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).extension<AppThemeColors>()!.active,
              ),
            ),
            fillColor:
                Theme.of(context).extension<AppThemeColors>()!.dropdownBg,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
