import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/widgets/presentation/section_title.dart';

class QuranSettings extends ConsumerWidget {
  const QuranSettings({super.key});

  final List<Map<String, String>> languages = const [
    {'label': 'Bangla', 'value': 'bn-bd'},
    {'label': 'English', 'value': 'en-gb'}
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var qSettings = ref.watch(quranSettingsProvider);
    var qNotifier = ref.read(quranSettingsProvider.notifier);
    String? selectedLanguage =
        qSettings.containsKey('language') ? qSettings['language'] : null;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'Language'),
              Dropdown(
                items: languages,
                selectedValue: selectedLanguage,
                allowClear: true,
                updateItem: (value) {
                  qNotifier.updateSettings('language', value!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
