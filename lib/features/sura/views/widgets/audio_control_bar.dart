import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../providers/sura_reciter_providers.dart';

class AudioControllerBar extends ConsumerWidget {
  final Color color;
  const AudioControllerBar({super.key, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranState = ref.watch(suraAudioProvider);
    if (quranState == null) return const SizedBox.shrink();

    final service = ref.read(suraAudioPlayerProvider);
    final surah = quranState.surah;
    final ayah = quranState.ayah;
    final isPlaying = quranState.isPlaying;

    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final foreground = appColors.primaryText;

    return Material(
      elevation: 6,
      color: appColors.cardBg,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: appColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text('$surah : $ayah',
                  style: TextStyle(
                    color: foreground,
                    fontSize: 16.sp,
                  )),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: appColors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Previous Ayah',
                  onPressed: service.playPrev,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: appColors.active,
                    size: 24.r,
                  ),
                  tooltip: isPlaying ? 'Pause' : 'Play',
                  onPressed: service.togglePlayPause,
                ),
                IconButton(
                  icon: Icon(
                    Icons.stop,
                    color: appColors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Stop',
                  onPressed: service.stop,
                ),
                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: appColors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Next Ayah',
                  onPressed: service.playNext,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
