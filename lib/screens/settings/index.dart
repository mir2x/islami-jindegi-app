import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/section_title.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'date_button.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  final List<Map<String, String>> languages = const [
    {'label': 'Bangla', 'value': 'bn'},
    {'label': 'English', 'value': 'en'},
  ];

  final List<Map<String, String>> banglaFonts = const [
    {'label': 'Solaiman Lipi', 'value': 'bangla/solaimanlipi'},
    {'label': 'Siyam Rupali', 'value': 'bangla/siyamrupali'},
    {'label': 'Kalpurush', 'value': 'bangla/kalpurush'},
  ];

  final List<Map<String, String>> arabicFonts = const [
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
    }
  ];

  final List<Map<String, String>> themes = const [
    {'label': 'Dark', 'value': 'dark'},
    {'label': 'Light', 'value': 'light'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var prefs = ref.watch(preferencesProvider);

    return AppScaffold(
      title: Text(locales.settings),
      body: prefs.when(
        loading: () => const FullScreenLoader(),
        error: (error, _) => Text(error.toString()),
        data: (preferences) {
          int selectedHijriAdj =
              preferences.getInt('hijriLocalAdjustment') ?? 0;

          String selectedLocale =
              languages.map((i) => i['value']).firstWhereOrNull((i) {
                    return i == preferences.getString('locale');
                  }) ??
                  'bn';

          String selectedArabicFont =
              arabicFonts.map((i) => i['value']).firstWhereOrNull((i) {
                    return i == preferences.getString('arabicFont');
                  }) ??
                  'arabic/al-mushaf';

          String selectedBanglaFont =
              banglaFonts.map((i) => i['value']).firstWhereOrNull((i) {
                    return i == preferences.getString('banglaFont');
                  }) ??
                  'bangla/solaimanlipi';

          String selectedTheme =
              themes.map((i) => i['value']).firstWhereOrNull((i) {
                    return i == preferences.getString('theme');
                  }) ??
                  'dark';

          return ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.hijriDateAdjustment),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DateButton(
                            label: '-2',
                            value: -2,
                            selectedValue: selectedHijriAdj,
                          ),
                          DateButton(
                            label: '-1',
                            value: -1,
                            selectedValue: selectedHijriAdj,
                          ),
                          DateButton(
                            label: '0',
                            value: 0,
                            selectedValue: selectedHijriAdj,
                          ),
                          DateButton(
                            label: '+1',
                            value: 1,
                            selectedValue: selectedHijriAdj,
                          ),
                          DateButton(
                            label: '+2',
                            value: 2,
                            selectedValue: selectedHijriAdj,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: locales.language),
                    Dropdown(
                      items: languages,
                      selectedValue: selectedLocale,
                      updateItem: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateLocale(value);
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
                    SectionTitle(title: locales.arabicFont),
                    Dropdown(
                      items: arabicFonts,
                      selectedValue: selectedArabicFont,
                      updateItem: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateArabicFont(value);
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
                    SectionTitle(title: locales.banglaFont),
                    Dropdown(
                      items: banglaFonts,
                      selectedValue: selectedBanglaFont,
                      updateItem: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateBanglaFont(value);
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
                    SectionTitle(title: locales.theme),
                    Dropdown(
                      items: themes,
                      selectedValue: selectedTheme,
                      updateItem: (value) {
                        ref
                            .read(preferencesProvider.notifier)
                            .updateTheme(value);
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
