import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'package:native_app/features/namaz_time/providers/prayer_alarm_providers.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/helpers/split_hijri_date.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/theme/app_theme_color.dart';

class NamazTimeItems extends ConsumerStatefulWidget {
  const NamazTimeItems({
    super.key,
    required this.currentDate,
    required this.isStartTime,
    this.onCalendarTap,
    this.selectedHijriDate,
  });

  final DateTime? currentDate;
  final bool isStartTime;
  final VoidCallback? onCalendarTap;
  final HijriCalendar? selectedHijriDate;

  @override
  NamazTimeItemsState createState() => NamazTimeItemsState();
}

class NamazTimeItemsState extends ConsumerState<NamazTimeItems> {
  Timer? timer;

  String? _detailRouteForPrayerKey(String prayerKey) {
    final slug = switch (prayerKey) {
      'tahajjud' => 'tahajjud',
      'fajr' => 'fajr',
      'sunrise' => 'sunrise',
      'ishraq' => 'ishraq',
      'midday' => 'midday',
      'dhuhr' => 'zuhr',
      'asr' => 'asr',
      'sunset' => 'sunset',
      'maghrib' => 'maghrib',
      'isha' => 'isha',
      _ => null,
    };

    return slug == null ? null : '/namaz-times/$slug';
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _timeUntil(
    DateTime? target,
    DateTime now,
    AppLocalizations locales,
    String lang,
  ) {
    if (target == null) return '';
    DateTime t = target;
    if (t.isBefore(now)) t = t.add(const Duration(days: 1));
    final diff = t.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours > 0) {
      return locales.inHoursMinutes(
        _localizeNumber(hours, lang),
        _localizeNumber(minutes, lang),
      );
    }
    return locales.inMinutes(_localizeNumber(minutes, lang));
  }

  String _localizeNumber(int n, String lang) {
    if (lang != 'bn') return n.toString();
    const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return n.toString().split('').map((c) {
      final d = int.tryParse(c);
      return d != null ? bnDigits[d] : c;
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = appTheme.primary == AppThemeColors.classic.primary &&
        appTheme.appBarBg == AppThemeColors.classic.appBarBg;
    final classicAccentForeground =
        isClassic ? appTheme.appBarBg : appTheme.active;
    final dateCardBorderColor = isClassic
        ? appTheme.secondary.withValues(alpha: 0.22)
        : appTheme.divider;
    final dataProvider = ref.watch(preferencesAndGeolocationProvider);
    final alarmStatesAsync = ref.watch(prayerAlarmProvider);

    return dataProvider.when(
      loading: () => Container(
        margin: const EdgeInsets.only(top: 100),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text(error.toString()),
      data: (Map data) {
        final prefs = data['preferences'];
        final Map geolocation = data['geolocation'];

        final prayerTime = PrayerTime(
          coordinates: Coordinates(
            geolocation['coordinates']['latitude'],
            geolocation['coordinates']['longitude'],
          ),
          timezone: geolocation['timezone'],
          preferences: prefs,
          currentDate: widget.currentDate,
        );

        final prayerTimes = prayerTime.getTimes(locales, currentLang);
        final tahajjud = prayerTimes['tahajjud']!;
        final fajr = prayerTimes['fajr']!;
        final sunrise = prayerTimes['sunrise']!;
        final ishraq = prayerTimes['ishraq']!;
        final midday = prayerTimes['midday']!;
        final dhuhr = prayerTimes['dhuhr']!;
        final asr = prayerTimes['asr']!;
        final sunset = prayerTimes['sunset']!;
        final maghrib = prayerTimes['maghrib']!;
        final isha = prayerTimes['isha']!;

        final prayerNames = prayerTime.currentAndNextPrayerNames();
        final String currentPrayerKey = prayerNames['currentPrayer']!;

        final String location = getLocationName(geolocation['location']);
        final int adjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;
        final HijriCalendar hijri = widget.selectedHijriDate ??
            adjustedHijriDate({
              'preferences': prefs,
              'coordinates': geolocation['coordinates'],
              'timezone': geolocation['timezone'],
              'hijriAdjustment': adjustment,
            });
        final hijriParts = splitHijriDate(hijri, locales, currentLang);
        final String hijriText =
            '${hijriParts['day']} ${hijriParts['month']} ${hijriParts['year']}';
        final DateTime displayDate = widget.currentDate ?? DateTime.now();
        final String gregorianText =
            DateFormat('EEEE, dd MMM yyyy', currentLang).format(displayDate);

        final alarmStates = alarmStatesAsync.when(
          loading: () => <String, bool>{},
          error: (_, __) => <String, bool>{},
          data: (states) => states,
        );

        final List<_PrayerData> prayers = [
          _PrayerData(
            keyName: 'tahajjud',
            title: tahajjud['title'],
            startTime: tahajjud['startTime'],
            endTime: tahajjud['endTime'],
            endDateTime: tahajjud['endDateTime'] as DateTime,
            icon: Icons.nightlight_round,
            route: _detailRouteForPrayerKey('tahajjud'),
          ),
          _PrayerData(
            keyName: 'fajr',
            title: fajr['title'],
            startTime: fajr['startTime'],
            endTime: fajr['endTime'],
            endDateTime: fajr['endDateTime'] as DateTime,
            icon: Icons.wb_twilight_outlined,
            route: '/namaz-times/fajr',
          ),
          _PrayerData(
            keyName: 'sunrise',
            title: sunrise['title'],
            startTime: sunrise['startTime'],
            endTime: sunrise['endTime'],
            endDateTime: sunrise['endDateTime'] as DateTime,
            icon: Icons.wb_twilight,
            isForbidden: true,
            route: _detailRouteForPrayerKey('sunrise'),
          ),
          _PrayerData(
            keyName: 'ishraq',
            title: ishraq['title'],
            startTime: ishraq['startTime'],
            endTime: ishraq['endTime'],
            endDateTime: ishraq['endDateTime'] as DateTime,
            icon: Icons.wb_sunny_outlined,
            route: _detailRouteForPrayerKey('ishraq'),
          ),
          _PrayerData(
            keyName: 'midday',
            title: midday['title'],
            startTime: midday['startTime'],
            endTime: midday['endTime'],
            endDateTime: midday['endDateTime'] as DateTime,
            icon: Icons.wb_sunny,
            isForbidden: true,
            route: _detailRouteForPrayerKey('midday'),
          ),
          _PrayerData(
            keyName: 'dhuhr',
            title: dhuhr['title'],
            startTime: dhuhr['startTime'],
            endTime: dhuhr['endTime'],
            endDateTime: dhuhr['endDateTime'] as DateTime,
            icon: Icons.sunny_snowing,
            route: '/namaz-times/zuhr',
          ),
          _PrayerData(
            keyName: 'asr',
            title: asr['title'],
            startTime: asr['startTime'],
            endTime: asr['endTime'],
            endDateTime: asr['endDateTime'] as DateTime,
            icon: Icons.sunny_snowing,
            route: '/namaz-times/asr',
          ),
          _PrayerData(
            keyName: 'sunset',
            title: sunset['title'],
            startTime: sunset['startTime'],
            endTime: sunset['endTime'],
            endDateTime: sunset['endDateTime'] as DateTime,
            icon: Icons.wb_twilight_outlined,
            isForbidden: true,
            route: _detailRouteForPrayerKey('sunset'),
          ),
          _PrayerData(
            keyName: 'maghrib',
            title: maghrib['title'],
            startTime: maghrib['startTime'],
            endTime: maghrib['endTime'],
            endDateTime: maghrib['endDateTime'] as DateTime,
            icon: Icons.nights_stay_outlined,
            route: '/namaz-times/maghrib',
          ),
          _PrayerData(
            keyName: 'isha',
            title: isha['title'],
            startTime: isha['startTime'],
            endTime: isha['endTime'],
            endDateTime: isha['endDateTime'] as DateTime,
            icon: Icons.bedtime_outlined,
            route: '/namaz-times/isha',
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Location ──────────────────────────────────────────────
            Row(
              children: [
                Text(
                  location,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appTheme.primaryText,
                  ),
                ),
                const SizedBox(width: 8),
                // Location change button
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.push('/location'),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: appTheme.highlight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: appTheme.divider),
                    ),
                    child: Icon(
                      Icons.place_outlined,
                      size: 13,
                      color: appTheme.active,
                    ),
                  ),
                ),
                if (widget.onCalendarTap != null) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: widget.onCalendarTap,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: appTheme.highlight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: appTheme.divider),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 13,
                        color: appTheme.active,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // ── Action icons — single row of 4 ───────────────────────────
            Row(
              children: [
                Expanded(
                  child: _ActionIcon(
                    icon: Icons.explore_outlined,
                    label: locales.qiblah,
                    onTap: () => context.push('/qiblah'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionIcon(
                    icon: Icons.mosque_outlined,
                    label: locales.mosques,
                    onTap: () async {
                      await ref
                          .read(geolocationProvider.notifier)
                          .updateCoordinates();
                      if (!context.mounted) return;
                      context.push('/mosques');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionIcon(
                    icon: Icons.alarm_outlined,
                    label: locales.prayerAlarm,
                    onTap: () => context.push('/namaz-times/alarms'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionIcon(
                    icon: Icons.settings_outlined,
                    label: locales.settings,
                    onTap: () => context.push('/namaz-times/settings'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Date card ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dateCardBorderColor),
                color: appTheme.highlight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hijriText,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: classicAccentForeground,
                    ),
                  ),
                  Text(
                    gregorianText,
                    style: textTheme.titleSmall?.copyWith(
                      color: appTheme.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Prayer cards ──────────────────────────────────────────
            ...prayers.map((p) {
              final bool isActive = currentPrayerKey == p.keyName;
              final bool hasAlarm =
                  PrayerAlarmService.prayerKeys.contains(p.keyName);
              final bool isAlarmEnabled = alarmStates[p.keyName] ?? false;
              final String timeLeft = isActive
                  ? _timeUntil(
                      p.endDateTime,
                      prayerTime.nowInPrayerTimezone,
                      locales,
                      currentLang,
                    )
                  : '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PrayerCard(
                  prayer: p,
                  isActive: isActive,
                  hasAlarm: hasAlarm,
                  isAlarmEnabled: isAlarmEnabled,
                  timeLeft: timeLeft,
                  onTap: p.route != null ? () => context.push(p.route!) : null,
                  onAlarmTap: () {
                    ref
                        .read(prayerAlarmProvider.notifier)
                        .toggleAlarm(p.keyName, !isAlarmEnabled);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          !isAlarmEnabled
                              ? '${locales.alarmEnabled} — ${p.title}'
                              : '${locales.alarmDisabled} — ${p.title}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

// ── Data holder ────────────────────────────────────────────────────────────────

class _PrayerData {
  const _PrayerData({
    required this.keyName,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.endDateTime,
    required this.icon,
    this.route,
    this.isForbidden = false,
  });

  final String keyName;
  final String title;
  final String startTime;
  final String endTime;
  final DateTime endDateTime;
  final IconData icon;
  final String? route;
  final bool isForbidden;
}

// ── Prayer card ────────────────────────────────────────────────────────────────

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({
    required this.prayer,
    required this.isActive,
    required this.hasAlarm,
    required this.isAlarmEnabled,
    required this.timeLeft,
    this.onTap,
    required this.onAlarmTap,
  });

  final _PrayerData prayer;
  final bool isActive;
  final bool hasAlarm;
  final bool isAlarmEnabled;
  final String timeLeft;
  final VoidCallback? onTap;
  final VoidCallback onAlarmTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isClassic = appTheme.primary == AppThemeColors.classic.primary &&
        appTheme.appBarBg == AppThemeColors.classic.appBarBg;
    final activeForeground = isClassic ? appTheme.appBarBg : appTheme.active;
    final activeBorderColor = isClassic
        ? appTheme.secondary.withValues(alpha: 0.34)
        : appTheme.highlightBorder;
    final inactiveBorderColor = isClassic
        ? appTheme.secondary.withValues(alpha: 0.2)
        : appTheme.divider;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double W = constraints.maxWidth;
        const double hPad = 12;
        const double iconW = 36;
        const double iconGap = 12;
        const double bellW = 40;

        // Bell centered at exactly W/2
        final double bellLeft = W / 2 - bellW / 2;
        // Name: from (hPad + iconW + iconGap) up to bell left edge
        final double nameWidth =
            (bellLeft - hPad - iconW - iconGap).clamp(0.0, double.infinity);

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isActive ? appTheme.highlight : appTheme.cardBg,
              border: Border.all(
                color: isActive ? activeBorderColor : inactiveBorderColor,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Stack(
              children: [
                // Main row content
                Padding(
                  padding: const EdgeInsets.only(
                    left: hPad,
                    top: 10,
                    bottom: 10,
                    right: hPad,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon with forbidden badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: iconW,
                            height: iconW,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? appTheme.cardBg
                                  : appTheme.highlight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              prayer.icon,
                              size: 18,
                              color: isActive
                                  ? activeForeground
                                  : appTheme.secondaryText,
                            ),
                          ),
                          if (prayer.isForbidden)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Tooltip(
                                message: AppLocalizations.of(context)!
                                    .forbiddenTimes,
                                child: const Icon(
                                  Icons.warning_rounded,
                                  size: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: iconGap),

                      // Prayer name — fills space up to bell
                      SizedBox(
                        width: nameWidth,
                        child: Text(
                          prayer.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: (isActive
                                  ? textTheme.titleLarge
                                  : textTheme.titleMedium)
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? activeForeground
                                : appTheme.primaryText,
                          ),
                        ),
                      ),

                      // Placeholder gap where the bell will be
                      const SizedBox(width: bellW),

                      // Time section — right-aligned on far right
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${prayer.startTime} – ${prayer.endTime}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: (isActive
                                      ? textTheme.labelLarge
                                      : textTheme.labelMedium)
                                  ?.copyWith(
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isActive
                                    ? activeForeground
                                    : appTheme.primaryText,
                              ),
                            ),
                            if (isActive && timeLeft.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                timeLeft,
                                textAlign: TextAlign.end,
                                style: textTheme.labelMedium?.copyWith(
                                  color: activeForeground,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bell — absolutely centered at W/2
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: bellLeft,
                  width: bellW,
                  child: Center(
                    child: hasAlarm
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onAlarmTap,
                            icon: Icon(
                              isAlarmEnabled
                                  ? Icons.notifications_active
                                  : Icons.notifications_none_outlined,
                              size: 20,
                              color: isAlarmEnabled
                                  ? activeForeground
                                  : appTheme.secondaryText,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Action icon (row of 4) ─────────────────────────────────────────────────────

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
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
    final isClassic = appTheme.primary == AppThemeColors.classic.primary &&
        appTheme.appBarBg == AppThemeColors.classic.appBarBg;
    final accentForeground = isClassic ? appTheme.appBarBg : appTheme.active;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: appTheme.cardBg,
          border: Border.all(color: appTheme.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.highlight,
              ),
              child: Icon(icon, color: accentForeground, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(
                color: appTheme.primaryText,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
