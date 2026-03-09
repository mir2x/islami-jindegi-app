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

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final dataProvider = ref.watch(preferencesAndGeolocationProvider);
    final alarmStatesProvider = ref.watch(prayerAlarmProvider);

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
        final prayerNames = prayerTime.currentAndNextPrayerNames();
        final String currentPrayerKey = prayerNames['currentPrayer']!;
        final String nextPrayerKey = prayerNames['nextPrayer']!;

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

        final DateTime? nextPrayerAt = _prayerDateTime(prayerTime, nextPrayerKey);
        final String upcomingIn = _timeUntil(nextPrayerAt, locales);

        final alarmStates = alarmStatesProvider.when(
          loading: () => <String, bool>{},
          error: (_, __) => <String, bool>{},
          data: (states) => states,
        );
        final bool anyAlarmOn = alarmStates.values.any((enabled) => enabled);

        final List<_PrayerRowData> dailyPrayers = [
          _PrayerRowData(
            keyName: 'fajr',
            title: prayerTimes['fajr']['title'],
            startTime: prayerTimes['fajr']['startTime'],
            endTime: prayerTimes['fajr']['endTime'],
            icon: Icons.wb_twilight_outlined,
            route: '/namaz-times/fajr',
          ),
          _PrayerRowData(
            keyName: 'dhuhr',
            title: prayerTimes['dhuhr']['title'],
            startTime: prayerTimes['dhuhr']['startTime'],
            endTime: prayerTimes['dhuhr']['endTime'],
            icon: Icons.wb_sunny_outlined,
            route: '/namaz-times/zuhr',
          ),
          _PrayerRowData(
            keyName: 'asr',
            title: prayerTimes['asr']['title'],
            startTime: prayerTimes['asr']['startTime'],
            endTime: prayerTimes['asr']['endTime'],
            icon: Icons.sunny_snowing,
            route: '/namaz-times/asr',
          ),
          _PrayerRowData(
            keyName: 'maghrib',
            title: prayerTimes['maghrib']['title'],
            startTime: prayerTimes['maghrib']['startTime'],
            endTime: prayerTimes['maghrib']['endTime'],
            icon: Icons.nights_stay_outlined,
            route: '/namaz-times/maghrib',
          ),
          _PrayerRowData(
            keyName: 'isha',
            title: prayerTimes['isha']['title'],
            startTime: prayerTimes['isha']['startTime'],
            endTime: prayerTimes['isha']['endTime'],
            icon: Icons.bedtime_outlined,
            route: '/namaz-times/isha',
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.push('/location'),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorScheme.outlineVariant),
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              ),
              child: Column(
                children: [
                  Text(
                    hijriText,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    gregorianText.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.4,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          colorScheme.surfaceContainerHighest,
                          colorScheme.surface.withValues(alpha: 0.92),
                        ]
                      : [
                          colorScheme.surfaceContainerHighest,
                          colorScheme.surface,
                        ],
                ),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locales.upcomingPrayer,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${prayerTimes[nextPrayerKey]['title']} $upcomingIn',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locales.nextPrayerLabel,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              prayerTimes[nextPrayerKey]['startTime'],
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => context.push('/namaz-times/alarms'),
                        child: Text(locales.setReminder),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.nightlight_round,
                    title: locales.sahurEnds,
                    value: prayerTimes['fajr']['startTime'],
                    accent: colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.fastfood_outlined,
                    title: locales.iftar,
                    value: prayerTimes['maghrib']['startTime'],
                    accent: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SectionHeader(
              title: locales.dailyPrayers,
              trailing: anyAlarmOn ? locales.autoAdhanOn : locales.autoAdhanOff,
            ),
            const SizedBox(height: 10),
            ...dailyPrayers.map((item) {
              final bool isActive = currentPrayerKey == item.keyName;
              final bool hasAlarm =
                  PrayerAlarmService.prayerKeys.contains(item.keyName);
              final bool isAlarmEnabled = alarmStates[item.keyName] ?? false;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PrayerRow(
                  title: item.title,
                  time: item.startTime,
                  endTime: item.endTime,
                  icon: item.icon,
                  isActive: isActive,
                  isAlarmEnabled: isAlarmEnabled,
                  hasAlarm: hasAlarm,
                  onTap: () => context.push(item.route),
                  onAlarmTap: () {
                    ref
                        .read(prayerAlarmProvider.notifier)
                        .toggleAlarm(item.keyName, !isAlarmEnabled);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          !isAlarmEnabled
                              ? '${locales.alarmEnabled} - ${item.title}'
                              : '${locales.alarmDisabled} - ${item.title}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
            _SectionHeader(title: locales.forbiddenTimes),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.wb_twilight,
                    title: prayerTimes['sunrise']['title'],
                    value:
                        '${prayerTimes['sunrise']['startTime']} - ${prayerTimes['sunrise']['endTime']}',
                    accent: colorScheme.secondary,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.wb_sunny,
                    title: prayerTimes['midday']['title'],
                    value:
                        '${prayerTimes['midday']['startTime']} - ${prayerTimes['midday']['endTime']}',
                    accent: colorScheme.secondary,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.wb_twilight_outlined,
                    title: prayerTimes['sunset']['title'],
                    value:
                        '${prayerTimes['sunset']['startTime']} - ${prayerTimes['sunset']['endTime']}',
                    accent: colorScheme.secondary,
                    isCompact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: colorScheme.inverseSurface.withValues(alpha: 0.92),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${locales.knowledge}\n${locales.knowledgeQuote}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onInverseSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.menu_book_outlined,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _ActionTile(
                  icon: Icons.explore_outlined,
                  title: locales.qiblah,
                  onTap: () => context.push('/qiblah'),
                ),
                _ActionTile(
                  icon: Icons.mosque_outlined,
                  title: locales.mosques,
                  onTap: () async {
                    await ref.read(geolocationProvider.notifier).updateCoordinates();
                    if (!context.mounted) return;
                    context.push('/mosques');
                  },
                ),
                _ActionTile(
                  icon: Icons.alarm_outlined,
                  title: locales.prayerAlarm,
                  onTap: () => context.push('/namaz-times/alarms'),
                ),
                _ActionTile(
                  icon: Icons.settings_outlined,
                  title: locales.settings,
                  onTap: () => context.push('/namaz-times/settings'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  DateTime? _prayerDateTime(PrayerTime prayerTime, String key) {
    switch (key) {
      case 'fajr':
        return prayerTime.prayerTimes.fajr;
      case 'sunrise':
        return prayerTime.prayerTimes.sunrise;
      case 'dhuhr':
        return prayerTime.prayerTimes.dhuhr;
      case 'asr':
        return prayerTime.prayerTimes.asr;
      case 'maghrib':
        return prayerTime.prayerTimes.maghrib;
      case 'isha':
        return prayerTime.prayerTimes.isha;
      default:
        return null;
    }
  }

  String _timeUntil(DateTime? nextPrayerAt, AppLocalizations locales) {
    if (nextPrayerAt == null) return '';
    final now = DateTime.now();
    DateTime target = nextPrayerAt;
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }
    final diff = target.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours > 0) {
      return locales.inHoursMinutes(hours, minutes);
    }
    return locales.inMinutes(minutes);
  }
}

class _PrayerRowData {
  const _PrayerRowData({
    required this.keyName,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.icon,
    required this.route,
  });

  final String keyName;
  final String title;
  final String startTime;
  final String endTime;
  final IconData icon;
  final String route;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.trailing,
  });

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
    this.isCompact = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color accent;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 10 : 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: accent, size: isCompact ? 16 : 18),
          SizedBox(height: isCompact ? 4 : 6),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: isCompact ? 15 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.title,
    required this.time,
    required this.endTime,
    required this.icon,
    required this.isActive,
    required this.isAlarmEnabled,
    required this.hasAlarm,
    required this.onTap,
    required this.onAlarmTap,
  });

  final String title;
  final String time;
  final String endTime;
  final IconData icon;
  final bool isActive;
  final bool isAlarmEnabled;
  final bool hasAlarm;
  final VoidCallback onTap;
  final VoidCallback onAlarmTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Color bgColor = isActive
        ? colorScheme.primary.withValues(alpha: 0.2)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
    final Color iconBg = isActive
        ? colorScheme.primary.withValues(alpha: 0.22)
        : colorScheme.surface.withValues(alpha: 0.75);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: bgColor,
          border: Border.all(
            color: isActive
                ? colorScheme.primary.withValues(alpha: 0.45)
                : colorScheme.outlineVariant.withValues(alpha: 0.65),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: isActive ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isActive ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.endsAt} $endTime',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (hasAlarm) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onAlarmTap,
                icon: Icon(
                  isAlarmEnabled ? Icons.notifications_active : Icons.notifications_off,
                  color: isAlarmEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
