import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/quran/providers/reciter_providers.dart';
import 'package:native_app/shared/quran_data.dart';
import '../../providers/sura_reciter_providers.dart';

class AudioRangeSelectionDialog extends ConsumerStatefulWidget {
  final int totalAyahs;
  final int suraNumber;

  const AudioRangeSelectionDialog({
    super.key,
    required this.totalAyahs,
    required this.suraNumber,
  });

  @override
  ConsumerState<AudioRangeSelectionDialog> createState() =>
      _AudioRangeSelectionDialogState();
}

class _AudioRangeSelectionDialogState
    extends ConsumerState<AudioRangeSelectionDialog> {
  bool _isFullSura = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedAudioSuraProvider.notifier).state = widget.suraNumber;
      ref.read(selectedStartAyahProvider.notifier).state = 1;
      ref.read(selectedEndAyahProvider.notifier).state = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedReciter = ref.watch(selectedReciterProvider);
    final startAyah = ref.watch(selectedStartAyahProvider);
    final endAyah = ref.watch(selectedEndAyahProvider);
    final repeatCount = ref.watch(selectedAyahRepeatCountProvider);

    final lastAyah = widget.totalAyahs;
    final ayahOptions = List.generate(lastAyah, (i) => i + 1);

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _labeledValue(
              label: 'সূরা',
              icon: HugeIcons.strokeRoundedQuran01,
              value: suraNames[widget.suraNumber - 1],
            ),
            SizedBox(height: 12.h),
            _labeledDropdown<String>(
              label: 'ক্বারী',
              icon: HugeIcons.strokeRoundedMuslim,
              value: reciters.entries
                  .firstWhere((e) => e.value == selectedReciter)
                  .key,
              items: reciters.keys.toList(),
              onChanged: (val) {
                if (val != null) {
                  ref
                      .read(selectedReciterProvider.notifier)
                      .setReciter(reciters[val]!);
                }
              },
            ),
            SizedBox(height: 12.h),
            _labeledDropdown<int>(
              label: 'শুরু আয়াত',
              icon: HugeIcons.strokeRoundedArrowLeft01,
              value: startAyah.clamp(1, lastAyah),
              items: ayahOptions,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _isFullSura = false);
                  ref.read(selectedStartAyahProvider.notifier).state = val;
                  final currentEndAyah = ref.read(selectedEndAyahProvider);
                  if (val > currentEndAyah) {
                    ref.read(selectedEndAyahProvider.notifier).state = val;
                  }
                }
              },
            ),
            SizedBox(height: 12.h),
            _labeledDropdown<int>(
              label: 'শেষ আয়াত',
              icon: HugeIcons.strokeRoundedArrowRight01,
              value: endAyah.clamp(startAyah, lastAyah),
              items: ayahOptions.where((a) => a >= startAyah).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _isFullSura = false);
                  ref.read(selectedEndAyahProvider.notifier).state = val;
                }
              },
            ),
            SizedBox(height: 12.h),
            _buildFullSuraCheckbox(
              onChanged: (isChecked) {
                setState(() => _isFullSura = isChecked);
                if (isChecked) {
                  ref.read(selectedStartAyahProvider.notifier).state = 1;
                  ref.read(selectedEndAyahProvider.notifier).state = lastAyah;
                }
              },
            ),
            SizedBox(height: 8.h),
            _buildRepeatStepper(
              repeatCount: repeatCount,
              onMinus: () {
                if (repeatCount > 0) {
                  ref.read(selectedAyahRepeatCountProvider.notifier).state =
                      repeatCount - 1;
                }
              },
              onPlus: () {
                ref.read(selectedAyahRepeatCountProvider.notifier).state =
                    repeatCount + 1;
              },
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPlay,
                  size: 24.r,
                  color: colorScheme.onPrimary,
                ),
                label: Text(
                  'অডিও শুনুন',
                  style:
                      TextStyle(fontSize: 16.sp, color: colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
                onPressed: () async {
                  final service = ref.read(suraAudioPlayerProvider);
                  final from = ref.read(selectedStartAyahProvider);
                  final to = ref.read(selectedEndAyahProvider);
                  final selectedRepeatCount =
                      ref.read(selectedAyahRepeatCountProvider);
                  final bool playbackStarted = await service.playAyahs(
                    from,
                    to,
                    context,
                    repeatCount: selectedRepeatCount,
                  );
                  if (!context.mounted) return;
                  if (playbackStarted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            SizedBox(height: 44.h),
          ],
        ),
      ),
    );
  }

  Widget _labeledValue({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HugeIcon(icon: icon, color: colorScheme.primary, size: 20.r),
        SizedBox(width: 8.w),
        Text(
          '$label:',
          style: TextStyle(
            color: textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textTheme.bodyLarge?.color,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _labeledDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HugeIcon(icon: icon, color: colorScheme.primary, size: 20.r),
        SizedBox(width: 8.w),
        Text(
          '$label:',
          style: TextStyle(
            color: textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                dropdownColor: colorScheme.surface,
                iconEnabledColor: colorScheme.primary,
                style: TextStyle(
                  color: textTheme.bodyLarge?.color,
                  fontSize: 16.sp,
                ),
                items: items.map((e) {
                  return DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      _localizedValueLabel(e),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textTheme.bodyLarge?.color,
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullSuraCheckbox({
    required ValueChanged<bool> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: _isFullSura,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: colorScheme.primary,
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () => onChanged(!_isFullSura),
          child: Text(
            'সম্পূর্ণ সূরা',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatStepper({
    required int repeatCount,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'আয়াতের পুনরাবৃত্তি',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(width: 12.w),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onMinus,
          color: colorScheme.primary,
        ),
        Text(
          repeatCount.toBengaliDigit(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onPlus,
          color: colorScheme.primary,
        ),
      ],
    );
  }

  String _localizedValueLabel<T>(T value) {
    if (value is int) {
      return value.toBengaliDigit();
    }
    return value.toString();
  }
}
