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
  });

  final DateTime? currentDate;
  final bool isStartTime;

  @override
  NamazTimeItemsState createState() => NamazTimeItemsState();
}

class NamazTimeItemsState extends ConsumerState<NamazTimeItems> {
  Timer? timer;

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

  String _timeUntil(DateTime? target, AppLocalizations locales, String lang) {
    if (target == null) return '';
    final now = DateTime.now();
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
        final fajr = prayerTimes['fajr']!;
        final dhuhr = prayerTimes['dhuhr']!;
        final asr = prayerTimes['asr']!;
        final maghrib = prayerTimes['maghrib']!;
        final isha = prayerTimes['isha']!;
        final sunrise = prayerTimes['sunrise']!;
        final midday = prayerTimes['midday']!;
        final sunset = prayerTimes['sunset']!;

        final prayerNames = prayerTime.currentAndNextPrayerNames();
        final String currentPrayerKey = prayerNames['currentPrayer']!;

        final String location = getLocationName(geolocation['location']);
        final int adjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;
        final HijriCalendar hijri = adjustedHijriDate({
          'preferences': prefs,
          'coordinates': geolocation['coordinates'],
          'timezone': geolocation['timezone'],
          'hijriAdjustment': adjustment,
        });
        final hijriParts = splitHijriDate(hijri, locales, currentLang);
        final String hijriText =
            '${hijriParts['day']} ${hijriParts['month']} ${hijriParts['year']}';
        final String gregorianText =
            DateFormat('EEEE, dd MMM yyyy', currentLang).format(DateTime.now());

        // Sehri ends = fajr start - 10 minutes
        final DateTime fajrStart = fajr['startDateTime'] as DateTime;
        final DateTime sehriEndsAt =
            fajrStart.subtract(const Duration(minutes: 10));
        final String sehriEndsTime =
            DateFormat.jm(currentLang).format(sehriEndsAt);

        final alarmStates = alarmStatesAsync.when(
          loading: () => <String, bool>{},
          error: (_, __) => <String, bool>{},
          data: (states) => states,
        );

        final List<_PrayerData> prayers = [
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
            keyName: 'dhuhr',
            title: dhuhr['title'],
            startTime: dhuhr['startTime'],
            endTime: dhuhr['endTime'],
            endDateTime: dhuhr['endDateTime'] as DateTime,
            icon: Icons.wb_sunny_outlined,
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
                Icon(Icons.place_outlined, size: 18, color: appTheme.active),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryText,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.push('/location'),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: appTheme.highlight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: appTheme.divider),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 17,
                      color: appTheme.primaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Date card ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appTheme.divider),
                color: appTheme.highlight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hijriText,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: appTheme.active,
                    ),
                  ),
                  Text(
                    gregorianText,
                    style: textTheme.labelSmall?.copyWith(
                      color: appTheme.secondaryText,
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
              final String timeLeft =
                  isActive ? _timeUntil(p.endDateTime, locales, currentLang) : '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PrayerCard(
                  prayer: p,
                  isActive: isActive,
                  hasAlarm: hasAlarm,
                  isAlarmEnabled: isAlarmEnabled,
                  timeLeft: timeLeft,
                  onTap: () => context.push(p.route),
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
            const SizedBox(height: 14),

            // ── Forbidden times (3 cols) ───────────────────────────────
            Text(
              locales.forbiddenTimes,
              style: textTheme.labelMedium?.copyWith(
                color: appTheme.secondaryText,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _SimpleTimeCard(
                    icon: Icons.wb_twilight,
                    label: sunrise['title'],
                    value:
                        '${sunrise['startTime']} – ${sunrise['endTime']}',
                    accent: appTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SimpleTimeCard(
                    icon: Icons.wb_sunny,
                    label: midday['title'],
                    value: '${midday['startTime']} – ${midday['endTime']}',
                    accent: appTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SimpleTimeCard(
                    icon: Icons.wb_twilight_outlined,
                    label: sunset['title'],
                    value:
                        '${sunset['startTime']} – ${sunset['endTime']}',
                    accent: appTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Sehri ends + Iftar (2 cols) ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _SimpleTimeCard(
                    icon: Icons.nightlight_round,
                    label: locales.sahurEnds,
                    value: sehriEndsTime,
                    accent: appTheme.active,
                    large: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SimpleTimeCard(
                    icon: Icons.fastfood_outlined,
                    label: locales.iftar,
                    value: maghrib['startTime'],
                    accent: appTheme.active,
                    large: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── 4 action icons ─────────────────────────────────────────
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
    required this.route,
  });

  final String keyName;
  final String title;
  final String startTime;
  final String endTime;
  final DateTime endDateTime;
  final IconData icon;
  final String route;
}

// ── Prayer card ────────────────────────────────────────────────────────────────

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({
    required this.prayer,
    required this.isActive,
    required this.hasAlarm,
    required this.isAlarmEnabled,
    required this.timeLeft,
    required this.onTap,
    required this.onAlarmTap,
  });

  final _PrayerData prayer;
  final bool isActive;
  final bool hasAlarm;
  final bool isAlarmEnabled;
  final String timeLeft;
  final VoidCallback onTap;
  final VoidCallback onAlarmTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isActive ? appTheme.highlight : appTheme.cardBg,
          border: Border.all(
            color:
                isActive ? appTheme.highlightBorder : appTheme.divider,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? appTheme.cardBg : appTheme.highlight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                prayer.icon,
                size: 18,
                color: isActive ? appTheme.active : appTheme.secondaryText,
              ),
            ),
            const SizedBox(width: 12),

            // Name + time-left badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayer.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color:
                          isActive ? appTheme.active : appTheme.primaryText,
                    ),
                  ),
                  if (isActive && timeLeft.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      timeLeft,
                      style: textTheme.labelSmall?.copyWith(
                        color: appTheme.active,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Start + end times
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  prayer.startTime,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color:
                        isActive ? appTheme.active : appTheme.primaryText,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.endsAt} ${prayer.endTime}',
                  style: textTheme.labelSmall?.copyWith(
                    color: appTheme.secondaryText,
                  ),
                ),
              ],
            ),

            // Alarm icon
            if (hasAlarm)
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onAlarmTap,
                  icon: Icon(
                    isAlarmEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_none_outlined,
                    size: 20,
                    color: isAlarmEnabled
                        ? appTheme.active
                        : appTheme.secondaryText,
                  ),
                ),
              )
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}

// ── Simple time card (forbidden / sehri / iftar) ───────────────────────────────

class _SimpleTimeCard extends StatelessWidget {
  const _SimpleTimeCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 12 : 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appTheme.divider),
        color: appTheme.cardBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: accent, size: large ? 20 : 16),
          SizedBox(height: large ? 6 : 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: appTheme.secondaryText,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
              fontSize: large ? null : 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall?.copyWith(
              color: appTheme.primaryText,
              fontWeight: FontWeight.w700,
              fontSize: large ? 16 : 12,
            ),
          ),
        ],
      ),
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

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: appTheme.cardBg,
          border: Border.all(color: appTheme.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.highlight,
              ),
              child: Icon(icon, color: appTheme.active, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(
                color: appTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
