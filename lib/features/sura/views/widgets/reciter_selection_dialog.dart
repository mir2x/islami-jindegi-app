import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../../quran/providers/reciter_providers.dart';

class ReciterSelectionDialog extends ConsumerWidget {
  const ReciterSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReciterId = ref.watch(selectedReciterProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
    final accent =
        isLight ? colors.secondaryText : Theme.of(context).colorScheme.primary;
    final selectedReciterName = reciters.entries
        .firstWhere((entry) => entry.value == selectedReciterId,
            orElse: () => reciters.entries.first)
        .key;

    return AlertDialog(
      title: const Text(
        'ক্বারী নির্বাচন করুন',
        style: TextStyle(
            wordSpacing: 3,
            fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: reciters.keys.map((reciterName) {
            return RadioListTile<String>(
              title: Text(
                reciterName,
                style: const TextStyle(wordSpacing: 3),
              ),
              value: reciterName,
              groupValue: selectedReciterName,
              onChanged: (String? value) {
                if (value != null && reciters.containsKey(value)) {
                  ref
                      .read(selectedReciterProvider.notifier)
                      .setReciter(reciters[value]!);

                  Navigator.of(context).pop();
                }
              },
              activeColor: accent,
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
                color: accent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      contentPadding: const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
    );
  }
}
