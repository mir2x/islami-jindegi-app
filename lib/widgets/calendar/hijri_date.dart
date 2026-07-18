import 'dart:async';
import 'package:flutter/material.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/split_hijri_date.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class HijriDate extends ConsumerStatefulWidget {
  const HijriDate({
    super.key,
    this.currentDate,
    this.count,
    this.oppositeColor = false,
    this.style,
  });

  final HijriCalendar? currentDate;
  final int? count;
  final bool oppositeColor;
  final TextStyle? style;

  @override
  ConsumerState<HijriDate> createState() => _HijriDateState();
}

class _HijriDateState extends ConsumerState<HijriDate> {
  Timer? _timer;
  Timer? _midnightTimer;

  @override
  void dispose() {
    _timer?.cancel();
    _midnightTimer?.cancel();
    super.dispose();
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final delay = midnight.difference(now) + const Duration(seconds: 1);
    debugPrint('[Hijri][Midnight] Scheduling refresh in ${delay.inMinutes}min');
    _midnightTimer = Timer(delay, () {
      if (!mounted) return;
      debugPrint('[Hijri][Midnight] Midnight reached — refreshing provider for new Gregorian date');
      ref.invalidate(hijriDateSettingsProvider);
      _scheduleMidnightRefresh();
    });
  }

  /// Schedules a one-shot timer that fires 1 second after today's Maghrib so
  /// the displayed date flips to the next Islamic day automatically.
  /// If Maghrib has already passed, schedules for tomorrow's Maghrib instead.
  /// Falls back to a 5-minute interval when Maghrib cannot be calculated.
  void _scheduleMaghribRefresh(Map settings) {
    _timer?.cancel();

    final now = DateTime.now();
    final todayMaghrib = getMaghribTime(settings, now);

    Duration delay;
    if (todayMaghrib != null) {
      if (now.isBefore(todayMaghrib)) {
        delay = todayMaghrib.difference(now) + const Duration(seconds: 1);
        debugPrint('[Hijri][Timer] Maghrib today: $todayMaghrib — scheduling in ${delay.inSeconds}s');
      } else {
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        final tomorrowMaghrib = getMaghribTime(settings, tomorrow);
        delay = tomorrowMaghrib != null
            ? tomorrowMaghrib.difference(now) + const Duration(seconds: 1)
            : const Duration(minutes: 5);
        debugPrint('[Hijri][Timer] Past Maghrib. Tomorrow Maghrib: $tomorrowMaghrib — scheduling in ${delay.inMinutes}min');
      }
    } else {
      // No Maghrib calculation — fall back to midnight local time.
      final midnight = DateTime(now.year, now.month, now.day + 1);
      delay = midnight.difference(now) + const Duration(seconds: 1);
      debugPrint('[Hijri][Timer] getMaghribTime=null. Scheduling for midnight in ${delay.inMinutes}min');
    }

    _timer = Timer(delay, () {
      if (!mounted) return;
      debugPrint('[Hijri][Timer] Timer fired — invalidating provider for fresh day data');
      // Invalidate so the provider re-fetches today's + tomorrow's data for the
      // new Gregorian date. This is essential for the second and subsequent
      // Maghrib transitions — the startup fetch's tomorrowData becomes stale.
      ref.invalidate(hijriDateSettingsProvider);
      // Schedule next timer. Coordinates/prefs in the current settings are still
      // valid for computing the next Maghrib even before the re-fetch completes.
      final latest = ref.read(hijriDateSettingsProvider).value;
      if (latest != null) _scheduleMaghribRefresh(latest);
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    // Schedule (or re-schedule) the Maghrib timer whenever settings change.
    ref.listen<AsyncValue<Map>>(hijriDateSettingsProvider, (_, next) {
      next.whenData(_scheduleMaghribRefresh);
    });

    return WithPreferences(
      builder: (context, preferences) {
        return settingsProvider.when(
          skipLoadingOnReload: true,
          loading: () {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '— ${locales.hijri}',
                  style: style ??
                      textTheme.labelMedium?.copyWith(
                        color: oppositeColor ? appColors.appBarText : null,
                      ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            );
          },
          error: (error, _) => Text(error.toString()),
          data: (Map settings) {
            // Ensure both timers are running (covers first load, not just changes).
            if (_timer == null || !_timer!.isActive) {
              _scheduleMaghribRefresh(settings);
            }
            if (_midnightTimer == null || !_midnightTimer!.isActive) {
              _scheduleMidnightRefresh();
            }

            HijriCalendar today;

            if (widget.currentDate != null) {
              today = widget.currentDate!;
            } else {
              today = adjustedHijriDate(settings);
            }

            Map h = splitHijriDate(today, locales, currentLang);
            String hijriDate = '${h['day']} ${h['month']}, ${h['year']}';
            String hijriText = '$hijriDate ${locales.hijri}';

            if (preferences.getString('hijriDate') != hijriDate) {
              preferences.setString('hijriDate', hijriDate);
              updateAppWidget({'hijriDate': hijriDate});
            }

            return Text(
              hijriText,
              style: style ??
                  textTheme.labelMedium?.copyWith(
                    color: oppositeColor ? appColors.appBarText : null,
                  ),
            );
          },
        );
      },
    );
  }

  TextStyle? get style => widget.style;
  bool get oppositeColor => widget.oppositeColor;
}
