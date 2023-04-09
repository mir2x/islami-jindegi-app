import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/section_title.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'time_input.dart';

class NamazSettings extends ConsumerWidget {
  const NamazSettings({super.key});

  final List<Map<String, String>> madhabs = const [
    {'label': 'Hanafi', 'value': 'hanafi'},
    {'label': 'Shafi / Maliki / Hanbali', 'value': 'shafi'}
  ];

  final List<Map<String, String>> methods = const [
    {'label': 'Karachi', 'value': 'Karachi'},
    {'label': 'Muslim World League', 'value': 'MuslimWorldLeague'},
    {'label': 'Umm Al-Qura, Makka', 'value': 'UmmAlQura'},
    {
      'label': 'Moonsighting Committee (North America and UK)',
      'value': 'MoonsightingCommittee'
    },
    {'label': 'Egyptian', 'value': 'Egyptian'},
    {'label': 'Dubai', 'value': 'Dubai'},
    {'label': 'Qatar', 'value': 'Qatar'},
    {'label': 'Kuwait', 'value': 'Kuwait'},
    {'label': 'Singapore, Malaysia and Indonesia', 'value': 'Singapore'},
    {'label': 'Turkey', 'value': 'Turkey'},
    {'label': 'Tehran', 'value': 'Tehran'},
    {'label': 'North America (ISNA)', 'value': 'NorthAmerica'}
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var prefs = ref.watch(preferencesProvider);

    return AppScaffold(
      title: Text(locales.namazSettings),
      body: prefs.when(
        loading: () => const FullScreenLoader(),
        error: (error, _) => Text(error.toString()),
        data: (preferences) {
          String selectedMadhab =
              madhabs.map((i) => i['value']).firstWhereOrNull((i) {
                    return i == preferences.getString('madhab');
                  }) ??
                  'hanafi';

          String selectedMethod =
              methods.map((i) => i['value']).firstWhereOrNull((i) {
                    return i == preferences.getString('method');
                  }) ??
                  'Karachi';

          int selectedFajr = preferences.getInt('fajr') ?? 5;
          int selectedSunrise = preferences.getInt('sunrise') ?? 0;
          int selectedDhuhr = preferences.getInt('dhuhr') ?? 0;
          int selectedAsr = preferences.getInt('asr') ?? 0;
          int selectedMaghrib = preferences.getInt('maghrib') ?? 3;
          int selectedIsha = preferences.getInt('isha') ?? 0;

          return ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.mazhab),
                    Dropdown(
                      items: madhabs,
                      selectedValue: selectedMadhab,
                      updateItem: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateMadhab(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.calcuationMethod),
                    Dropdown(
                      items: methods,
                      selectedValue: selectedMethod,
                      updateItem: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateMethod(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.fajr),
                    TimeInput(
                      initialValue: selectedFajr.toString(),
                      onChanged: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateFajr(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.sunrise),
                    TimeInput(
                      initialValue: selectedSunrise.toString(),
                      onChanged: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateSunrise(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.zuhr),
                    TimeInput(
                      initialValue: selectedDhuhr.toString(),
                      onChanged: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateDhuhr(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.asr),
                    TimeInput(
                      initialValue: selectedAsr.toString(),
                      onChanged: (value) {
                        ref.read(preferencesProvider.notifier).updateAsr(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.maghrib),
                    TimeInput(
                      initialValue: selectedMaghrib.toString(),
                      onChanged: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateMaghrib(value);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.isha),
                    TimeInput(
                      initialValue: selectedIsha.toString(),
                      onChanged: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateIsha(value);
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
}
