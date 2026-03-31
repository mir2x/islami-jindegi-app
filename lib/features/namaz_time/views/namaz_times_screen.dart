import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/theme/app_theme_color.dart';

import 'namaz_time_items.dart';

class NamazTimes extends ConsumerWidget {
  const NamazTimes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.namazTime),
      body: settingsProvider.when(
        loading: () {
          var dataProvider = ref.watch(preferencesAndGeolocationProvider);

          return dataProvider.when(
            loading: () => Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(error.toString()),
            data: (Map data) {
              int? localAdjustment =
                  data['preferences'].getInt('hijriLocalAdjustment');
              int adjustment = localAdjustment ?? 0;

              return NamazTimesPage(
                settings: {
                  'preferences': data['preferences'],
                  'coordinates': data['geolocation']['coordinates'],
                  'timezone': data['geolocation']['timezone'],
                  'hijriAdjustment': adjustment,
                },
                isHijriLoading: true,
              );
            },
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (settings) {
          return NamazTimesPage(settings: settings);
        },
      ),
    );
  }
}

class NamazTimesPage extends ConsumerStatefulWidget {
  const NamazTimesPage({
    super.key,
    required this.settings,
    this.isHijriLoading = false,
  });

  final Map settings;
  final bool isHijriLoading;

  @override
  NamazTimesPageState createState() => NamazTimesPageState();
}

class NamazTimesPageState extends ConsumerState<NamazTimesPage> {
  DateTime? _selectedGregorianDate;
  HijriCalendar? _selectedHijriDate;

  void _showCalendarSheet(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                locales.customDate,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: appTheme.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _CalendarOption(
                icon: Icons.calendar_month_outlined,
                label: locales.hijri,
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showHijriPicker(context);
                },
              ),
              const SizedBox(height: 10),
              _CalendarOption(
                icon: Icons.calendar_month_outlined,
                label: locales.english,
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showGregorianPicker(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHijriPicker(BuildContext context) {
    final settings = ref.read(hijriDateSettingsProvider).valueOrNull;
    if (settings == null) return;

    HijriCalendar today;
    int adjustedWeekdayNumber = 0;
    final int adjustment = settings['hijriAdjustment'] as int;
    adjustedWeekdayNumber -= adjustment;

    if (_selectedHijriDate != null) {
      today = _selectedHijriDate!;
    } else {
      today = adjustedHijriDate(settings);
      if (isAfterDateStartTime(DateTime.now(), settings)) {
        adjustedWeekdayNumber -= 1;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: HijriMonthPicker(
            builders: HijriCalendarBuilders(
              weekdayBuilder: (context, day, number) {
                final localizations = MaterialLocalizations.of(context);
                final int num = (number + adjustedWeekdayNumber) % 7;
                final String weekday = localizations.narrowWeekdays[num];
                return Center(child: Text(weekday));
              },
            ),
            selectedDate: today,
            firstDate: HijriCalendar()
              ..hYear = 1400
              ..hMonth = 1
              ..hDay = 1,
            lastDate: HijriCalendar()
              ..hYear = 1500
              ..hMonth = 1
              ..hDay = 1,
            onChanged: (HijriCalendar value) {
              setState(() {
                _selectedHijriDate = value;
                _selectedGregorianDate =
                    value.hijriToGregorian(value.hYear, value.hMonth, value.hDay);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ),
      ),
    );
  }

  void _showGregorianPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 300,
          height: 300,
          child: DatePicker(
            selectedDate: _selectedGregorianDate,
            minDate: DateTime(633, 1, 1),
            maxDate: DateTime(2100, 1, 1),
            onDateSelected: (DateTime value) {
              setState(() => _selectedGregorianDate = value);
              Navigator.of(ctx).pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ItemContent(
      fullWidth: true,
      children: [
        NamazTimeItems(
          currentDate: _selectedGregorianDate,
          isStartTime: true,
          onCalendarTap: () => _showCalendarSheet(context),
          selectedHijriDate: _selectedHijriDate,
        ),
      ],
    );
  }
}

class _CalendarOption extends StatelessWidget {
  const _CalendarOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appTheme.divider),
          color: appTheme.cardBg,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: appTheme.active),
            const SizedBox(width: 12),
            Text(
              label,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: appTheme.primaryText,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 18, color: appTheme.secondaryText),
          ],
        ),
      ),
    );
  }
}
