import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/theme/colors.dart';
import 'package:native_app/services/prayer_alarm_service.dart';
import '../providers/prayer_alarm_providers.dart';

class PrayerAlarmScreen extends ConsumerWidget {
  const PrayerAlarmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var alarmStates = ref.watch(prayerAlarmProvider);

    return AppScaffold(
      title: Text(locales.alarmSettings),
      body: alarmStates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text(error.toString()),
        data: (Map<String, bool> states) {
          bool allEnabled = states.values.every((v) => v);

          return ItemContent(
            children: [
              // ───── Master Toggle ─────
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ThemeColors.color7,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locales.allAlarms,
                      style: textTheme.titleMedium?.copyWith(
                        color: ThemeColors.color3,
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
                      activeColor: ThemeColors.color8,
                    ),
                  ],
                ),
              ),

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
    String currentLang = Localizations.localeOf(context).languageCode;
    String prayerLabel =
        PrayerAlarmService.getPrayerDisplayLabel(prayerKey, currentLang);

    var beforeOffset = ref.watch(prayerBeforeOffsetProvider(prayerKey));
    var afterOffset = ref.watch(prayerAfterOffsetProvider(prayerKey));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isEnabled
            ? ThemeColors.color5.withOpacity(0.15)
            : ThemeColors.color3,
        border: Border.all(
          color: isEnabled ? ThemeColors.color5 : ThemeColors.border,
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
                      color:
                          isEnabled ? ThemeColors.color5 : ThemeColors.border,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      prayerLabel,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isEnabled
                            ? ThemeColors.color1
                            : ThemeColors.color13,
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
                  activeColor: ThemeColors.color8,
                ),
              ],
            ),
          ),

          // ───── Offset Controls (only when enabled) ─────
          if (isEnabled)
            Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 12, top: 4),
              child: Column(
                children: [
                  // Before waqt offset
                  _OffsetRow(
                    label: locales.beforeWaqt,
                    offset: beforeOffset,
                    onChanged: (value) {
                      ref
                          .read(prayerBeforeOffsetProvider(prayerKey).notifier)
                          .setOffset(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  // After waqt offset
                  _OffsetRow(
                    label: locales.afterWaqt,
                    offset: afterOffset,
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

class _OffsetRow extends StatelessWidget {
  const _OffsetRow({
    required this.label,
    required this.offset,
    required this.onChanged,
  });

  final String label;
  final AsyncValue<int> offset;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: ThemeColors.color13,
          ),
        ),
        offset.when(
          loading: () => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const Text('—'),
          data: (value) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ThemeColors.border),
            ),
            child: DropdownButton<int>(
              value: value,
              underline: const SizedBox(),
              isDense: true,
              items: PrayerAlarmService.offsetOptions
                  .map(
                    (opt) => DropdownMenuItem<int>(
                      value: opt,
                      child: Text(
                        opt == 0 ? '—' : '$opt min',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }
}
