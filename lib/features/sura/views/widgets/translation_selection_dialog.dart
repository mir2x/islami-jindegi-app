import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../providers/sura_providers.dart';

const List<String> availableTranslators = [
  'মুফতী তাকী উসমানী',
  'মাওলানা মুহিউদ্দিন খান',
  'ইসলামিক ফাউন্ডেশন',
  'Taqi Usmani',
];

class TranslatorSelectionDialog extends ConsumerWidget {
  const TranslatorSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTranslatorsProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return AlertDialog(
      backgroundColor: colors.cardBg,
      surfaceTintColor: colors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: colors.divider),
      ),
      title: const Text(
        'অনুবাদক নির্বাচন করুন',
        style: TextStyle(
          wordSpacing: 3,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableTranslators.map((translatorName) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                translatorName,
                style: TextStyle(
                  wordSpacing: 3,
                  color: colors.primaryText,
                ),
              ),
              value: selected.contains(translatorName),
              onChanged: (bool? isSelected) {
                ref
                    .read(selectedTranslatorsProvider.notifier)
                    .toggleTranslator(translatorName);
              },
              activeColor: colors.active,
              checkColor: colors.appBarText,
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'বন্ধ করুন',
            style: TextStyle(
              wordSpacing: 3,
              color: colors.active,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      contentPadding: const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
    );
  }
}
