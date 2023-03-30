import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/section_title.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'time_input.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var prefs = ref.watch(preferencesProvider);

    return MyScaffold(
      title: Text(locales.settings),
      body: prefs.when(
        loading: () => const FullScreenLoader(),
        error: (error, _) => Text(error.toString()),
        data: (preferences) {
          return StatefulSettings(preferences: preferences);
        },
      ),
    );
  }
}

class StatefulSettings extends ConsumerStatefulWidget {
  const StatefulSettings({
    super.key,
    required this.preferences,
  });

  final dynamic preferences;

  final List<Map<String, String>> locales = const [
    {'label': 'Bangla', 'value': 'bn'},
    {'label': 'English', 'value': 'en'}
  ];

  final List<Map<String, String>> banglaFonts = const [
    {'label': 'Solaiman Lipi', 'value': 'bangla/solaimanlipi'},
    {'label': 'Siyam Rupali', 'value': 'bangla/siyamrupali'},
    {'label': 'Kalpurush', 'value': 'bangla/kalpurush'}
  ];

  final List<Map<String, String>> arabicFonts = const [
    {'label': 'Al Qalam Quran Majeed', 'value': 'arabic/al-qalam'},
    {
      'label': 'Al Qalam Kolkatta Quran Majeed',
      'value': 'arabic/al-qalam-kolkatta'
    }
  ];

  final List<Map<String, String>> themes = const [
    {'label': 'Dark', 'value': 'dark'},
    {'label': 'Light', 'value': 'light'}
  ];

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
  SettingsState createState() => SettingsState();
}

class SettingsState extends ConsumerState<StatefulSettings> {
  String? selectedLocale;
  String? selectedArabicFont;
  String? selectedBanglaFont;
  String? selectedTheme;
  String? selectedMadhab;
  String? selectedMethod;
  int? selectedFajr;
  int? selectedSunrise;
  int? selectedDhuhr;
  int? selectedAsr;
  int? selectedMaghrib;
  int? selectedIsha;

  @override
  void initState() {
    super.initState();

    selectedLocale =
        widget.locales.map((i) => i['value']).firstWhereOrNull((i) {
              return i == widget.preferences.getString('locale');
            }) ??
            'en';

    selectedArabicFont =
        widget.arabicFonts.map((i) => i['value']).firstWhereOrNull((i) {
              return i == widget.preferences.getString('arabicFont');
            }) ??
            'arabic/al-qalam';

    selectedBanglaFont =
        widget.banglaFonts.map((i) => i['value']).firstWhereOrNull((i) {
              return i == widget.preferences.getString('banglaFont');
            }) ??
            'bangla/solaimanlipi';

    selectedTheme = widget.themes.map((i) => i['value']).firstWhereOrNull((i) {
          return i == widget.preferences.getString('theme');
        }) ??
        'dark';

    selectedMadhab =
        widget.madhabs.map((i) => i['value']).firstWhereOrNull((i) {
              return i == widget.preferences.getString('madhab');
            }) ??
            'hanafi';

    selectedMethod =
        widget.methods.map((i) => i['value']).firstWhereOrNull((i) {
              return i == widget.preferences.getString('method');
            }) ??
            'Karachi';

    selectedFajr = widget.preferences.getInt('fajr') ?? 5;
    selectedSunrise = widget.preferences.getInt('sunrise') ?? 0;
    selectedDhuhr = widget.preferences.getInt('dhuhr') ?? 0;
    selectedAsr = widget.preferences.getInt('asr') ?? 0;
    selectedMaghrib = widget.preferences.getInt('maghrib') ?? 3;
    selectedIsha = widget.preferences.getInt('isha') ?? 0;
  }

  updateLocale(String? value) {
    setState(() {
      selectedLocale = value;
      ref.read(preferencesProvider.notifier).updateLocale(value);
    });
  }

  updateArabicFont(String? value) {
    setState(() {
      selectedArabicFont = value;
      widget.preferences.setString('arabicFont', value);
    });
  }

  updateBanglaFont(String? value) {
    setState(() {
      selectedBanglaFont = value;
      widget.preferences.setString('banglaFont', value);
    });
  }

  updateTheme(String? value) {
    setState(() {
      selectedTheme = value;
      widget.preferences.setString('theme', value);
    });
  }

  updateMadhab(String? value) {
    setState(() {
      selectedMadhab = value;
      widget.preferences.setString('madhab', value);
    });
  }

  updateMethod(String? value) {
    setState(() {
      selectedMethod = value;
      widget.preferences.setString('method', value);
    });
  }

  updateFajr(String value) {
    setState(() {
      if (int.tryParse(value) != null) {
        int intValue = int.parse(value);
        selectedFajr = intValue;
        widget.preferences.setInt('fajr', intValue);
      }
    });
  }

  updateSunrise(String value) {
    setState(() {
      if (int.tryParse(value) != null) {
        int intValue = int.parse(value);
        selectedSunrise = intValue;
        widget.preferences.setInt('sunrise', intValue);
      }
    });
  }

  updateDhuhr(String value) {
    setState(() {
      if (int.tryParse(value) != null) {
        int intValue = int.parse(value);
        selectedDhuhr = intValue;
        widget.preferences.setInt('dhuhr', intValue);
      }
    });
  }

  updateAsr(String value) {
    setState(() {
      if (int.tryParse(value) != null) {
        int intValue = int.parse(value);
        selectedAsr = intValue;
        widget.preferences.setInt('asr', intValue);
      }
    });
  }

  updateMaghrib(String value) {
    setState(() {
      if (int.tryParse(value) != null) {
        int intValue = int.parse(value);
        selectedMaghrib = intValue;
        widget.preferences.setInt('maghrib', intValue);
      }
    });
  }

  updateIsha(String value) {
    setState(() {
      if (int.tryParse(value) != null) {
        int intValue = int.parse(value);
        selectedIsha = intValue;
        widget.preferences.setInt('isha', intValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return ItemContent(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(title: locales.language),
              Dropdown(
                items: widget.locales,
                selectedValue: selectedLocale,
                updateItem: updateLocale,
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
                items: widget.arabicFonts,
                selectedValue: selectedArabicFont,
                updateItem: updateArabicFont,
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
                items: widget.banglaFonts,
                selectedValue: selectedBanglaFont,
                updateItem: updateBanglaFont,
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
                items: widget.themes,
                selectedValue: selectedTheme,
                updateItem: updateTheme,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(title: locales.mazhab),
              Dropdown(
                items: widget.madhabs,
                selectedValue: selectedMadhab,
                updateItem: updateMadhab,
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
                items: widget.methods,
                selectedValue: selectedMethod,
                updateItem: updateMethod,
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
                onChanged: updateFajr,
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
                onChanged: updateSunrise,
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
                onChanged: updateDhuhr,
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
                onChanged: updateAsr,
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
                onChanged: updateMaghrib,
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
                onChanged: updateIsha,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
