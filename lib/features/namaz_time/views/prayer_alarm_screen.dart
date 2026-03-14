import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                      onChanged: (value) {
                        ref
                            .read(prayerAlarmProvider.notifier)
                            .toggleAllAlarms(value);
                      },
                      activeColor: colorScheme.tertiary,
                    ),
                  ],
                ),
              ),

              // ───── Global Sound Picker ─────
              _SoundPicker(),

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

// ─────────────────────────────────────────────────────────────
// Sound picker (global — one sound for all prayers)
// ─────────────────────────────────────────────────────────────

class _SoundPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    String lang = Localizations.localeOf(context).languageCode;
    var soundAsync = ref.watch(alarmSoundProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              Icon(Icons.music_note, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                locales.azanSound,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          soundAsync.when(
            loading: () => const SizedBox(
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (selectedKey) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PrayerAlarmService.azanSounds.map((sound) {
                final key = sound['key']!;
                final label =
                    lang == 'bn' ? sound['labelBn']! : sound['labelEn']!;
                final isSelected = selectedKey == key;
                return GestureDetector(
                  onTap: () {
                    ref.read(alarmSoundProvider.notifier).setSound(key);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      label,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Per-prayer card
// ─────────────────────────────────────────────────────────────

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

    var beforeOffset = ref.watch(prayerBeforeOffsetProvider(prayerKey));
    var afterOffset = ref.watch(prayerAfterOffsetProvider(prayerKey));
    var repeatDays = ref.watch(prayerRepeatDaysProvider(prayerKey));

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
                  onChanged: (value) {
                    ref
                        .read(prayerAlarmProvider.notifier)
                        .toggleAlarm(prayerKey, value);

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

                  // ── Repeat days ──
                  _RepeatDaysRow(
                    prayerKey: prayerKey,
                    repeatDays: repeatDays,
                    lang: currentLang,
                    locales: locales,
                  ),

                  const SizedBox(height: 12),

                  // ── Before waqt slider ──
                  _OffsetSlider(
                    label: locales.beforeWaqt,
                    isBefore: true,
                    offset: beforeOffset,
                    lang: currentLang,
                    onChanged: (value) {
                      ref
                          .read(prayerBeforeOffsetProvider(prayerKey).notifier)
                          .setOffset(value);
                    },
                  ),

                  const SizedBox(height: 10),

                  // ── After waqt slider ──
                  _OffsetSlider(
                    label: locales.afterWaqt,
                    isBefore: false,
                    offset: afterOffset,
                    lang: currentLang,
                    onChanged: (value) {
                      ref
                          .read(prayerAfterOffsetProvider(prayerKey).notifier)
                          .setOffset(value);
                    },
                  ),
                ],
              ),
            ),
        ],
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
                children: [
                  // "Every day" chip
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

// ─────────────────────────────────────────────────────────────
// Offset slider (replaces the old dropdown)
// ─────────────────────────────────────────────────────────────

class _OffsetSlider extends StatelessWidget {
  const _OffsetSlider({
    required this.label,
    required this.isBefore,
    required this.offset,
    required this.lang,
    required this.onChanged,
  });

  final String label;
  final bool isBefore;
  final AsyncValue<int> offset;
  final String lang;
  final void Function(int) onChanged;

  String _formatValue(int value) {
    if (value == 0) {
      return lang == 'bn' ? 'ওয়াক্তের সময়ে' : 'At waqt time';
    }
    if (lang == 'bn') {
      return isBefore ? '$value মিনিট আগে' : '$value মিনিট পরে';
    }
    return isBefore ? '$value min before' : '$value min after';
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return offset.when(
      loading: () => const SizedBox(
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: value > 0
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: value > 0
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
                child: Text(
                  _formatValue(value),
                  style: textTheme.bodySmall?.copyWith(
                    color: value > 0
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.outlineVariant,
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withAlpha(38),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: PrayerAlarmService.maxOffsetMinutes.toDouble(),
              divisions: PrayerAlarmService.maxOffsetMinutes,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
        ],
      ),
    );
  }
}
