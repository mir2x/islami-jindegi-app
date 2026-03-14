import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'package:native_app/providers/notification_status.dart';
import '../providers/prayer_alarm_providers.dart';

// Weekday order: Mon=1 … Sun=7
const _weekdays = [1, 2, 3, 4, 5, 6, 7];

String _dayLabel(int weekday, String lang) {
  const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const bn = ['সোম', 'মঙ্গল', 'বুধ', 'বৃহস্', 'শুক্র', 'শনি', 'রবি'];
  final labels = lang == 'bn' ? bn : en;
  return labels[weekday - 1];
}

Future<bool> _ensureAlarmPermissions(WidgetRef ref) async {
  var notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted && !notificationStatus.isProvisional) {
    notificationStatus = await Permission.notification.request();
    await ref.read(notificationStatusProvider.notifier).updateStatus();
  }

  if (!notificationStatus.isGranted && !notificationStatus.isProvisional) {
    if (notificationStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  if (Platform.isAndroid) {
    var exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    if (!exactAlarmStatus.isGranted) {
      exactAlarmStatus = await Permission.scheduleExactAlarm.request();
      await ref.read(exactAlarmPermissionProvider.notifier).updateStatus();
    }

    if (!exactAlarmStatus.isGranted) {
      await openAppSettings();
      return false;
    }
  }

  return true;
}

class PrayerAlarmScreen extends ConsumerWidget {
  const PrayerAlarmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var alarmStates = ref.watch(prayerAlarmProvider);
    var colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      title: Text(locales.alarmSettings),
      body: alarmStates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text(error.toString()),
        data: (Map<String, bool> states) {
          bool allEnabled = states.values.every((v) => v);

          return ItemContent(
            children: [
              const _AlarmPermissionStatusCard(),

              const SizedBox(height: 12),

              const _NextAlarmSummaryCard(),

              const SizedBox(height: 12),

              // ───── Master Toggle ─────
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locales.allAlarms,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: allEnabled,
                      onChanged: (value) async {
                        if (value && !await _ensureAlarmPermissions(ref)) {
                          return;
                        }
                        ref
                            .read(prayerAlarmProvider.notifier)
                            .toggleAllAlarms(value);
                      },
                      activeColor: colorScheme.tertiary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ───── Per-Prayer Cards ─────
              ...PrayerAlarmService.prayerKeys.map((prayerKey) {
                bool isEnabled = states[prayerKey] ?? false;
                return _PrayerAlarmCard(
                  prayerKey: prayerKey,
                  isEnabled: isEnabled,
                );
              }),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class _AlarmPermissionStatusCard extends ConsumerWidget {
  const _AlarmPermissionStatusCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final notificationStatus = ref.watch(notificationStatusProvider);
    final exactAlarmStatus = ref.watch(exactAlarmPermissionProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'অ্যালার্ম পারমিশন',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          notificationStatus.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => Text(
              error.toString(),
              style: textTheme.bodySmall,
            ),
            data: (status) => _PermissionRow(
              icon: Icons.notifications_active_outlined,
              title: 'নোটিফিকেশন',
              subtitle: _permissionLabel(status, grantedLabel: 'অনুমোদিত'),
              isGranted: status.isGranted || status.isProvisional,
              onPressed: () => _requestNotificationPermission(ref),
            ),
          ),
          if (Platform.isAndroid) const SizedBox(height: 10),
          if (Platform.isAndroid)
            exactAlarmStatus.when(
              loading: () => const SizedBox.shrink(),
              error: (error, _) => Text(
                error.toString(),
                style: textTheme.bodySmall,
              ),
              data: (status) => _PermissionRow(
                icon: Icons.alarm_outlined,
                title: 'এক্স্যাক্ট অ্যালার্ম',
                subtitle: _permissionLabel(
                  status,
                  grantedLabel: 'অনুমোদিত',
                ),
                isGranted: status.isGranted,
                onPressed: () => _requestExactAlarmPermission(ref),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            'এগুলোর কোনোটি বন্ধ থাকলে কিছু Android ডিভাইসে আযানের অ্যালার্ম কাজ নাও করতে পারে।',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  static String _permissionLabel(
    PermissionStatus status, {
    required String grantedLabel,
  }) {
    if (status.isGranted || status.isProvisional) {
      return grantedLabel;
    }
    if (status.isPermanentlyDenied) {
      return 'সেটিংস থেকে চালু করতে হবে';
    }
    if (status.isRestricted) {
      return 'ডিভাইস দ্বারা সীমাবদ্ধ';
    }
    return 'অনুমতি প্রয়োজন';
  }

  static Future<void> _requestNotificationPermission(WidgetRef ref) async {
    final status = await Permission.notification.request();
    await ref.read(notificationStatusProvider.notifier).updateStatus();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  static Future<void> _requestExactAlarmPermission(WidgetRef ref) async {
    final status = await Permission.scheduleExactAlarm.request();
    await ref.read(exactAlarmPermissionProvider.notifier).updateStatus();
    if (!status.isGranted) {
      await openAppSettings();
    }
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGranted;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isGranted ? colorScheme.primary : colorScheme.error,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (!isGranted)
          TextButton(
            onPressed: onPressed,
            child: const Text('চালু করুন'),
          )
        else
          Icon(
            Icons.check_circle,
            size: 18,
            color: colorScheme.primary,
          ),
      ],
    );
  }
}

class _NextAlarmSummaryCard extends ConsumerWidget {
  const _NextAlarmSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentLang = Localizations.localeOf(context).languageCode;
    final alarmStates = ref.watch(prayerAlarmProvider);
    final nextAlarmAsync = ref.watch(nextEnabledPrayerAlarmProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colorScheme.primaryContainer,
        border: Border.all(color: colorScheme.primary),
      ),
      child: alarmStates.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (states) {
          final anyEnabled = states.values.any((enabled) => enabled);
          if (!anyEnabled) {
            return Text(
              currentLang == 'bn'
                  ? 'কোনো নামাজের অ্যালার্ম চালু নেই।'
                  : 'No prayer alarms are enabled.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            );
          }

          return nextAlarmAsync.when(
            loading: () => Row(
              children: [
                Icon(Icons.schedule, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  currentLang == 'bn'
                      ? 'পরবর্তী অ্যালার্ম প্রস্তুত করা হচ্ছে...'
                      : 'Preparing next alarm...',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            error: (_, __) => Text(
              currentLang == 'bn'
                  ? 'পরবর্তী অ্যালার্ম দেখানো যাচ্ছে না।'
                  : 'Unable to show the next alarm.',
              style: textTheme.bodyMedium,
            ),
            data: (info) {
              if (info == null) {
                return Text(
                  currentLang == 'bn'
                      ? 'চালু অ্যালার্ম আছে, কিন্তু পরবর্তী সময় নির্ধারণ করা যায়নি।'
                      : 'Alarms are enabled, but the next schedule could not be determined.',
                  style: textTheme.bodyMedium,
                );
              }

              final prayerLabel = PrayerAlarmService.getPrayerDisplayLabel(
                info.prayerKey,
                currentLang,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentLang == 'bn' ? 'পরবর্তী অ্যালার্ম' : 'Next alarm',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$prayerLabel • ${PrayerAlarmService.formatScheduleSummary(info, currentLang)}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentLang == 'bn'
                        ? 'ওয়াক্ত: ${DateFormat.jm(currentLang).format(info.nextPrayerTime)}'
                        : 'Waqt: ${DateFormat.jm(currentLang).format(info.nextPrayerTime)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PrayerAlarmCard extends ConsumerWidget {
  const _PrayerAlarmCard({
    required this.prayerKey,
    required this.isEnabled,
  });

  final String prayerKey;
  final bool isEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    String currentLang = Localizations.localeOf(context).languageCode;
    String prayerLabel =
        PrayerAlarmService.getPrayerDisplayLabel(prayerKey, currentLang);

    var reminderMode = ref.watch(prayerReminderModeProvider(prayerKey));
    var reminderOffset = ref.watch(prayerReminderOffsetProvider(prayerKey));
    var repeatDays = ref.watch(prayerRepeatDaysProvider(prayerKey));
    var soundKey = ref.watch(prayerAlarmSoundProvider(prayerKey));
    var scheduleInfo = ref.watch(prayerAlarmScheduleProvider(prayerKey));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isEnabled ? colorScheme.primaryContainer : colorScheme.surface,
        border: Border.all(
          color: isEnabled ? colorScheme.primary : colorScheme.outlineVariant,
          width: isEnabled ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // ───── Prayer Name + Toggle ─────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isEnabled ? Icons.alarm_on : Icons.alarm_off,
                      color: isEnabled
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      prayerLabel,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isEnabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (value) async {
                    if (value && !await _ensureAlarmPermissions(ref)) {
                      return;
                    }
                    ref
                        .read(prayerAlarmProvider.notifier)
                        .toggleAlarm(prayerKey, value);
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? '${locales.alarmEnabled} — $prayerLabel'
                              : '${locales.alarmDisabled} — $prayerLabel',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  activeColor: colorScheme.tertiary,
                ),
              ],
            ),
          ),

          // ───── Expanded controls (only when enabled) ─────
          if (isEnabled)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 14,
                top: 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  _SchedulePreviewCard(
                    prayerKey: prayerKey,
                    prayerLabel: prayerLabel,
                    scheduleInfo: scheduleInfo,
                    currentLang: currentLang,
                  ),

                  const SizedBox(height: 12),

                  _ReminderModeSection(
                    prayerKey: prayerKey,
                    currentLang: currentLang,
                    reminderMode: reminderMode,
                    reminderOffset: reminderOffset,
                  ),

                  const SizedBox(height: 14),

                  // ── Repeat days ──
                  _RepeatDaysRow(
                    prayerKey: prayerKey,
                    repeatDays: repeatDays,
                    lang: currentLang,
                    locales: locales,
                  ),

                  const SizedBox(height: 14),

                  _PrayerSoundSection(
                    prayerKey: prayerKey,
                    currentLang: currentLang,
                    soundKey: soundKey,
                  ),

                  const SizedBox(height: 12),

                  _PrayerActionRow(
                    prayerKey: prayerKey,
                    currentLang: currentLang,
                    soundKey: soundKey,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SchedulePreviewCard extends StatelessWidget {
  const _SchedulePreviewCard({
    required this.prayerKey,
    required this.prayerLabel,
    required this.scheduleInfo,
    required this.currentLang,
  });

  final String prayerKey;
  final String prayerLabel;
  final AsyncValue<PrayerAlarmScheduleInfo?> scheduleInfo;
  final String currentLang;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: scheduleInfo.when(
        loading: () => Text(
          currentLang == 'bn' ? 'পরবর্তী অ্যালার্ম হিসাব করা হচ্ছে...' : 'Calculating next alarm...',
          style: textTheme.bodySmall,
        ),
        error: (_, __) => Text(
          currentLang == 'bn' ? 'পরবর্তী অ্যালার্ম দেখানো যাচ্ছে না।' : 'Unable to show next alarm.',
          style: textTheme.bodySmall,
        ),
        data: (info) {
          if (info == null) {
            return Text(
              currentLang == 'bn'
                  ? '$prayerLabel অ্যালার্ম চালু আছে, তবে পরবর্তী সময় পাওয়া যায়নি।'
                  : '$prayerLabel alarm is enabled, but the next time is unavailable.',
              style: textTheme.bodySmall,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentLang == 'bn' ? 'পরবর্তী রিমাইন্ডার' : 'Next reminder',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                PrayerAlarmService.formatScheduleSummary(info, currentLang),
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentLang == 'bn'
                    ? 'নামাজের ওয়াক্ত: ${DateFormat.jm(currentLang).format(info.nextPrayerTime)}'
                    : 'Prayer time: ${DateFormat.jm(currentLang).format(info.nextPrayerTime)}',
                style: textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Repeat days row
// ─────────────────────────────────────────────────────────────

class _RepeatDaysRow extends StatelessWidget {
  const _RepeatDaysRow({
    required this.prayerKey,
    required this.repeatDays,
    required this.lang,
    required this.locales,
  });

  final String prayerKey;
  final AsyncValue<Set<int>> repeatDays;
  final String lang;
  final AppLocalizations locales;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locales.repeatDays,
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 6),
        repeatDays.when(
          loading: () => const SizedBox(
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (days) => Consumer(
            builder: (context, ref, _) {
              bool isEveryDay = days.length == 7;
              return Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _DayChip(
                    label: locales.everyday,
                    selected: isEveryDay,
                    onTap: () {
                      if (!isEveryDay) {
                        ref
                            .read(prayerRepeatDaysProvider(prayerKey).notifier)
                            .setDays({1, 2, 3, 4, 5, 6, 7});
                      }
                    },
                  ),
                  _DayChip(
                    label: lang == 'bn' ? 'কর্মদিবস' : 'Weekdays',
                    selected: !isEveryDay &&
                        days.length == 5 &&
                        const {1, 2, 3, 4, 5}.containsAll(days),
                    onTap: () {
                      ref
                          .read(prayerRepeatDaysProvider(prayerKey).notifier)
                          .setDays({1, 2, 3, 4, 5});
                    },
                  ),
                  _DayChip(
                    label: lang == 'bn' ? 'শুক্রবার' : 'Friday',
                    selected: days.length == 1 && days.contains(5),
                    onTap: () {
                      ref
                          .read(prayerRepeatDaysProvider(prayerKey).notifier)
                          .setDays({5});
                    },
                  ),
                  ..._weekdays.map((d) {
                    final selected = !isEveryDay && days.contains(d);
                    return _DayChip(
                      label: _dayLabel(d, lang),
                      selected: selected,
                      onTap: () {
                        final current = Set<int>.from(days);
                        if (isEveryDay) {
                          // Switching from "every day" to a specific day
                          ref
                              .read(
                                prayerRepeatDaysProvider(prayerKey).notifier,
                              )
                              .setDays({d});
                        } else {
                          if (current.contains(d) && current.length > 1) {
                            current.remove(d);
                          } else if (!current.contains(d)) {
                            current.add(d);
                          }
                          // If all 7 selected, switch back to "every day"
                          final next = current.length == 7
                              ? {1, 2, 3, 4, 5, 6, 7}
                              : current;
                          ref
                              .read(
                                prayerRepeatDaysProvider(prayerKey).notifier,
                              )
                              .setDays(next);
                        }
                      },
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color:
                selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ReminderModeSection extends ConsumerWidget {
  const _ReminderModeSection({
    required this.prayerKey,
    required this.currentLang,
    required this.reminderMode,
    required this.reminderOffset,
  });

  final String prayerKey;
  final String currentLang;
  final AsyncValue<String> reminderMode;
  final AsyncValue<int> reminderOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return reminderMode.when(
      loading: () => const SizedBox(
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (mode) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentLang == 'bn' ? 'রিমাইন্ডারের ধরন' : 'Reminder type',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ModeChip(
                label: currentLang == 'bn' ? 'ওয়াক্তের সময়' : 'At waqt',
                selected: mode == PrayerAlarmService.reminderModeAt,
                onTap: () {
                  ref
                      .read(prayerReminderModeProvider(prayerKey).notifier)
                      .setMode(PrayerAlarmService.reminderModeAt);
                },
              ),
              _ModeChip(
                label: currentLang == 'bn' ? 'আগে' : 'Before',
                selected: mode == PrayerAlarmService.reminderModeBefore,
                onTap: () {
                  ref
                      .read(prayerReminderModeProvider(prayerKey).notifier)
                      .setMode(PrayerAlarmService.reminderModeBefore);
                },
              ),
              _ModeChip(
                label: currentLang == 'bn' ? 'পরে' : 'After',
                selected: mode == PrayerAlarmService.reminderModeAfter,
                onTap: () {
                  ref
                      .read(prayerReminderModeProvider(prayerKey).notifier)
                      .setMode(PrayerAlarmService.reminderModeAfter);
                },
              ),
            ],
          ),
          if (mode != PrayerAlarmService.reminderModeAt) ...[
            const SizedBox(height: 10),
            reminderOffset.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (selectedOffset) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PrayerAlarmService.reminderOffsetChoices
                    .map(
                      (choice) => _OffsetChoiceChip(
                        label: currentLang == 'bn'
                            ? '$choice মিনিট'
                            : '$choice min',
                        selected: selectedOffset == choice,
                        onTap: () {
                          ref
                              .read(
                                prayerReminderOffsetProvider(prayerKey)
                                    .notifier,
                              )
                              .setOffset(choice);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrayerSoundSection extends ConsumerWidget {
  const _PrayerSoundSection({
    required this.prayerKey,
    required this.currentLang,
    required this.soundKey,
  });

  final String prayerKey;
  final String currentLang;
  final AsyncValue<String> soundKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentLang == 'bn' ? 'এই নামাজের সাউন্ড' : 'Sound for this prayer',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        soundKey.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (selectedKey) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PrayerAlarmService.azanSounds.map((sound) {
              final key = sound['key']!;
              final label =
                  currentLang == 'bn' ? sound['labelBn']! : sound['labelEn']!;
              return _OffsetChoiceChip(
                label: label,
                selected: selectedKey == key,
                onTap: () {
                  ref
                      .read(prayerAlarmSoundProvider(prayerKey).notifier)
                      .setSound(key);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PrayerActionRow extends ConsumerWidget {
  const _PrayerActionRow({
    required this.prayerKey,
    required this.currentLang,
    required this.soundKey,
  });

  final String prayerKey;
  final String currentLang;
  final AsyncValue<String> soundKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSoundKey = soundKey.valueOrNull ?? PrayerAlarmService.defaultSoundKey;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _previewSound(selectedSoundKey),
            icon: const Icon(Icons.volume_up_outlined),
            label: Text(currentLang == 'bn' ? 'শুনে দেখুন' : 'Preview'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: () async {
              if (!await _ensureAlarmPermissions(ref)) {
                return;
              }
              await PrayerAlarmService.scheduleTestAlarm(
                prayerKey,
                locale: currentLang,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    currentLang == 'bn'
                        ? '৮ সেকেন্ড পরে পরীক্ষামূলক অ্যালার্ম বাজবে'
                        : 'A test alarm will ring in 8 seconds',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.alarm),
            label: Text(currentLang == 'bn' ? 'টেস্ট অ্যালার্ম' : 'Test alarm'),
          ),
        ),
      ],
    );
  }

  static Future<void> _previewSound(String soundKey) async {
    final player = AudioPlayer();
    try {
      await player.setAsset(PrayerAlarmService.getSoundPath(soundKey));
      player.play();
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          player.dispose();
        }
      });
    } catch (_) {
      await player.dispose();
    }
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _OffsetChoiceChip(
      label: label,
      selected: selected,
      onTap: onTap,
    );
  }
}

class _OffsetChoiceChip extends StatelessWidget {
  const _OffsetChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color:
                selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
