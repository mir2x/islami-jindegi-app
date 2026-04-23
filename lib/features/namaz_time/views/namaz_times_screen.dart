import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart'
    show
        adjustedHijriDate,
        displayHijriToPickerHijri,
        hijriWeekdayShift,
        pickerHijriToDisplayHijri;
import 'package:native_app/helpers/hijri_localization.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/calendar/gregorian_month_picker.dart';

import 'namaz_time_items.dart';

class NamazTimes extends ConsumerWidget {
  const NamazTimes({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
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
              return NamazTimesPage(
                settings: {
                  'preferences': data['preferences'],
                  'coordinates': data['geolocation']['coordinates'],
                  'timezone': data['geolocation']['timezone'],
                },
                isHijriLoading: true,
                initialDate: initialDate,
              );
            },
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (settings) {
          return NamazTimesPage(settings: settings, initialDate: initialDate);
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
    this.initialDate,
  });

  final Map settings;
  final bool isHijriLoading;
  final DateTime? initialDate;

  @override
  NamazTimesPageState createState() => NamazTimesPageState();
}

class NamazTimesPageState extends ConsumerState<NamazTimesPage> {
  DateTime? _selectedGregorianDate;
  HijriCalendar? _selectedHijriDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedGregorianDate = widget.initialDate;
    }
  }

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

    final HijriCalendar bdToday = adjustedHijriDate(settings);
    final HijriCalendar selected = _selectedGregorianDate != null
        ? pickerHijriToDisplayHijri(
            settings,
            HijriCalendar.fromDate(_selectedGregorianDate!),
          )
        : (_selectedHijriDate ?? bdToday);
    final HijriCalendar pickerSelected =
        displayHijriToPickerHijri(settings, selected);
    final int shift = hijriWeekdayShift(settings);
    final String lang = Localizations.localeOf(context).languageCode;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: HijriMonthPicker(
            builders: HijriCalendarBuilders(
              weekdayBuilder: (context, day, number) {
                final localizations = MaterialLocalizations.of(context);
                final String weekday =
                    localizations.narrowWeekdays[(number + shift) % 7];
                return Center(child: Text(weekday));
              },
              monthYearBuilder: (context, month, year) {
                final displayMonth = pickerHijriToDisplayHijri(
                  settings,
                  HijriCalendar()
                    ..hYear = year
                    ..hMonth = month
                    ..hDay = 15,
                );
                final monthLabel = lang == 'bn'
                    ? hijriMonthYearBengali(
                        displayMonth.hMonth,
                        displayMonth.hYear,
                      )
                    : hijriMonthYearEnglish(
                        displayMonth.hMonth,
                        displayMonth.hYear,
                      );
                return Text(
                  monthLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
              dayBuilder: (context, hijriDay, isSelected) {
                final th = Theme.of(context);
                final loc = MaterialLocalizations.of(context);
                final displayDay =
                    pickerHijriToDisplayHijri(settings, hijriDay);
                final isToday = displayDay.hYear == bdToday.hYear &&
                    displayDay.hMonth == bdToday.hMonth &&
                    displayDay.hDay == bdToday.hDay;
                BoxDecoration? deco;
                TextStyle? style = th.textTheme.bodyMedium;
                if (isSelected) {
                  style = th.textTheme.bodyLarge
                      ?.copyWith(color: th.colorScheme.onSecondary);
                  deco = BoxDecoration(
                      color: th.colorScheme.secondary, shape: BoxShape.circle,);
                } else if (isToday) {
                  style = th.textTheme.bodyLarge
                      ?.copyWith(color: th.colorScheme.secondary);
                }
                return Container(
                  decoration: deco,
                  child: Center(
                    child: Text(
                      loc.formatDecimal(displayDay.hDay),
                      style: style,
                    ),
                  ),
                );
              },
            ),
            selectedDate: pickerSelected,
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
                _selectedHijriDate =
                    pickerHijriToDisplayHijri(settings, value);
                _selectedGregorianDate = value.hijriToGregorian(
                  value.hYear,
                  value.hMonth,
                  value.hDay,
                );
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
          child: GregorianMonthPicker(
            selectedDate: _selectedGregorianDate ?? DateTime.now(),
            firstDate: DateTime(633, 1, 1),
            lastDate: DateTime(2100, 1, 1),
            onChanged: (DateTime value) {
              setState(() {
                _selectedGregorianDate = value;
                _selectedHijriDate = null;
              });
              Navigator.of(ctx).pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HijriCalendar? selectedHijriDate = _selectedGregorianDate != null
        ? pickerHijriToDisplayHijri(
            widget.settings,
            HijriCalendar.fromDate(_selectedGregorianDate!),
          )
        : _selectedHijriDate;

    return ItemContent(
      fullWidth: true,
      children: [
        NamazTimeItems(
          currentDate: _selectedGregorianDate,
          isStartTime: true,
          onCalendarTap: () => _showCalendarSheet(context),
          selectedHijriDate: selectedHijriDate,
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
