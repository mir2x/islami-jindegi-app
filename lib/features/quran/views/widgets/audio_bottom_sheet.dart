import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../providers/audio_providers.dart';
import '../../providers/ayah_highlight_providers.dart';
import '../../providers/reciter_providers.dart';

class AudioBottomSheet extends ConsumerStatefulWidget {
  final int currentSura;

  const AudioBottomSheet({super.key, required this.currentSura});

  @override
  ConsumerState<AudioBottomSheet> createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends ConsumerState<AudioBottomSheet> {
  bool _isFullSura = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedAudioSuraProvider.notifier).state = widget.currentSura;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedAudioSura = ref.watch(selectedAudioSuraProvider);
    final selectedReciter = ref.watch(selectedReciterProvider);
    final startAyah = ref.watch(selectedStartAyahProvider);
    final endAyah = ref.watch(selectedEndAyahProvider);
    final repeatCount = ref.watch(selectedAyahRepeatCountProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);
    final suraNames = ref.watch(suraNamesProvider);

    final lastAyah = ayahCounts[selectedAudioSura - 1];
    final ayahOptions = List.generate(lastAyah, (i) => i + 1);
    final suraNameOptions = suraNames;

    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            _labeledDropdown<String>(
              label: 'সূরা',
              icon: HugeIcons.strokeRoundedArrowRight01,
              value: suraNames[selectedAudioSura - 1],
              items: suraNameOptions,
              onChanged: (val) {
                if (val != null) {
                  final newSuraIndex = suraNames.indexOf(val);
                  if (newSuraIndex != -1) {
                    final newSuraNumber = newSuraIndex + 1;
                    ref.read(selectedAudioSuraProvider.notifier).state =
                        newSuraNumber;

                    ref.read(selectedStartAyahProvider.notifier).state = 1;
                    ref.read(selectedEndAyahProvider.notifier).state = 1;
                    setState(() => _isFullSura = false);
                  }
                }
              },
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
                    color: colors.appBarText),
                label: Text('অডিও শুনুন',
                    style:
                        TextStyle(fontSize: 16.sp, color: colors.appBarText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.active,
                  foregroundColor: colors.appBarText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onPressed: () async {
                  final service = ref.read(quranAudioPlayerProvider);
                  final from = ref.read(selectedStartAyahProvider);
                  final to = ref.read(selectedEndAyahProvider);
                  final selectedRepeatCount =
                      ref.read(selectedAyahRepeatCountProvider);
                  final bool playbackStarted = await service.playAyahs(
                      from, to, context,
                      repeatCount: selectedRepeatCount);
                  if (!context.mounted) return;
                  if (playbackStarted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _labeledDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HugeIcon(icon: icon, color: colors.active, size: 20.r),
        SizedBox(width: 8.w),
        Text(
          '$label:',
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.highlight,
              border: Border.all(color: colors.divider),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                dropdownColor: colors.dropdownBg,
                iconEnabledColor: colors.active,
                style: TextStyle(color: colors.primaryText, fontSize: 16.sp),
                items: items.map((e) {
                  return DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      _localizedValueLabel(e),
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: colors.primaryText, fontSize: 16.sp),
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
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: Checkbox(
              value: _isFullSura,
              onChanged: (value) => onChanged(value ?? false),
              activeColor: colors.active,
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
                color: colors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatStepper({
    required int repeatCount,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'আয়াতের পুনরাবৃত্তি',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: colors.primaryText,
            ),
          ),
          SizedBox(width: 12.w),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onMinus,
            color: colors.active,
          ),
          Text(
            repeatCount.toBengaliDigit(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colors.active,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onPlus,
            color: colors.active,
          ),
        ],
      ),
    );
  }

  String _localizedValueLabel<T>(T value) {
    if (value is int) {
      return value.toBengaliDigit();
    }
    return value.toString();
  }
}
