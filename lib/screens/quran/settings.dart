import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/widgets/presentation/section_title.dart';

class QuranSettings extends ConsumerWidget {
  const QuranSettings({super.key});

  final List<Map<String, String>> languages = const [
    {'label': 'Bangla', 'value': 'bn'},
    {'label': 'English', 'value': 'en'}
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var qSettings = ref.watch(quranSettingsProvider);
    var qNotifier = ref.read(quranSettingsProvider.notifier);

    var qitabQuery = ref.watch(
      allModelsProvider(AllModelsQuery(repository: ref.tafseerQitabs)),
    );

    var qariQuery = ref.watch(
      allModelsProvider(AllModelsQuery(repository: ref.qaris)),
    );

    String? selectedLanguage =
        qSettings.containsKey('language') ? qSettings['language'] : null;

    String? selectedQitab =
        qSettings.containsKey('qitab') ? qSettings['qitab'] : null;

    String? selectedQari =
        qSettings.containsKey('qari') ? qSettings['qari'] : null;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(title: locales.translations),
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
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(title: locales.tafseerQitabs),
              qitabQuery.when(
                loading: () {
                  return Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 10),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                },
                error: (error, _) => Text(error.toString()),
                data: (resources) {
                  var qitabs = resources
                      .map<Map<String, String>>(
                        (r) => {'label': r.title, 'value': r.id},
                      )
                      .toList();

                  return Dropdown(
                    items: qitabs,
                    selectedValue: selectedQitab,
                    allowClear: true,
                    updateItem: (value) {
                      qNotifier.updateSettings('qitab', value!);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(title: locales.qaris),
              qariQuery.when(
                loading: () {
                  return Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 10),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                },
                error: (error, _) => Text(error.toString()),
                data: (resources) {
                  var qaris = resources
                      .map<Map<String, String>>(
                        (r) => {'label': r.name, 'value': r.slug},
                      )
                      .toList();

                  return Dropdown(
                    items: qaris,
                    selectedValue: selectedQari,
                    allowClear: true,
                    updateItem: (value) {
                      qNotifier.updateSettings('qari', value!);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
