import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/widgets/calendar/bangali_date.dart';
import 'package:native_app/widgets/calendar/gregorian_date.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/widgets/calendar/bd_hijri_month_picker.dart';
import 'package:native_app/widgets/calendar/gregorian_month_picker.dart';
import 'current_dates.dart';
import 'current_location_prayers.dart';

class DatesPrayers extends ConsumerStatefulWidget {
  const DatesPrayers({super.key});

  @override
  ConsumerState<DatesPrayers> createState() => _DatesPrayersState();
}

class _DatesPrayersState extends ConsumerState<DatesPrayers> {
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

    final today = adjustedHijriDate(settings);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: BdHijriMonthPicker(
            settings: settings,
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
              Navigator.of(ctx).pop();
              final gregorian = displayHijriToGregorian(settings, value);
              if (context.mounted) {
                context.push('/namaz-times', extra: gregorian);
              }
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
            selectedDate: DateTime.now(),
            firstDate: DateTime(633, 1, 1),
            lastDate: DateTime(2100, 1, 1),
            onChanged: (DateTime value) {
              Navigator.of(ctx).pop();
              if (context.mounted) {
                context.push('/namaz-times', extra: value);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    double screenWidth = media.size.width;
    final screenHeight = media.size.height;
    bool isMobile = screenWidth < 768;
    final isShortMobile = isMobile && screenHeight < 760;
    final isVeryShortMobile = isMobile && screenHeight < 700;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    var textTheme = Theme.of(context).textTheme;

    if (isMobile) {
      final headlineStyle = (isVeryShortMobile
              ? textTheme.titleLarge
              : isShortMobile
                  ? textTheme.headlineSmall
                  : textTheme.headlineMedium)
          ?.copyWith(
            color: appColors.appBarText,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          );
      final metaStyle = (isVeryShortMobile
              ? textTheme.labelSmall
              : textTheme.bodySmall)
          ?.copyWith(
            color: appColors.appBarText.withValues(alpha: 0.85),
          );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HijriDate(
                oppositeColor: true,
                style: headlineStyle,
              ),
              SizedBox(width: isVeryShortMobile ? 6 : 8),
              _HeroCalendarButton(
                appColors: appColors,
                compact: isShortMobile,
                onTap: () => _showHijriPicker(context),
              ),
            ],
          ),
          SizedBox(height: isVeryShortMobile ? 1 : 3),
          Row(
            children: [
              GregorianDate(
                oppositeColor: true,
                style: metaStyle,
              ),
              SizedBox(width: isVeryShortMobile ? 6 : 8),
              _HeroCalendarButton(
                appColors: appColors,
                compact: isShortMobile,
                onTap: () => _showGregorianPicker(context),
              ),
            ],
          ),
          SizedBox(height: isVeryShortMobile ? 1 : 2),
          BangaliDate(
            oppositeColor: true,
            style: metaStyle,
          ),
          SizedBox(height: isVeryShortMobile ? 4 : 6),
          _LocationRow(
            appColors: appColors,
            textTheme: textTheme,
            compact: isShortMobile,
          ),
          SizedBox(height: isVeryShortMobile ? 6 : 10),
          _PrayerCard(compact: isShortMobile),
        ],
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CurrentDates(),
          CurrentLocationPrayers(),
        ],
      );
    }
  }
}

class _HeroCalendarButton extends StatelessWidget {
  const _HeroCalendarButton({
    required this.appColors,
    required this.onTap,
    this.compact = false,
  });

  final AppThemeColors appColors;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: compact ? 22 : 24,
        height: compact ? 22 : 24,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(
          Icons.calendar_month_outlined,
          size: compact ? 12 : 13,
          color: appColors.appBarText.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}

class _LocationRow extends ConsumerWidget {
  const _LocationRow({
    required this.appColors,
    required this.textTheme,
    this.compact = false,
  });

  final AppThemeColors appColors;
  final TextTheme textTheme;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geoData = ref.watch(geolocationProvider);

    return geoData.maybeWhen(
      data: (geo) {
        final location = getLocationName(geo['location']);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              location,
              style: (compact ? textTheme.bodySmall : textTheme.bodyMedium)?.copyWith(
                color: appColors.appBarText.withValues(alpha: 0.85),
              ),
            ),
            SizedBox(width: compact ? 6 : 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push('/location'),
              child: Container(
                width: compact ? 22 : 24,
                height: compact ? 22 : 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Icon(
                  Icons.place_outlined,
                  size: compact ? 12 : 13,
                  color: appColors.appBarText,
                ),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(compact ? 18 : 20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: CurrentLocationPrayers(heroCard: true, compactHero: compact),
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
