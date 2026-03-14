import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/audio_providers.dart';
import 'package:native_app/features/sura/views/widgets/reciter_selection_dialog.dart';
import 'package:native_app/theme/app_theme_color.dart';

class AudioControllerBar extends ConsumerWidget {
  final Color color;
  const AudioControllerBar({super.key, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranState = ref.watch(quranAudioProvider);
    if (quranState == null) return const SizedBox.shrink();
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    final service = ref.read(quranAudioPlayerProvider);
    final surah = quranState.surah;
    final ayah = quranState.ayah;
    final isPlaying = quranState.isPlaying;

    return Material(
      elevation: 6,
      color: colors.cardBg,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$surah : $ayah',
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: colors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Previous Ayah',
                  onPressed: service.playPrev,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: colors.active,
                    size: 24.r,
                  ),
                  tooltip: isPlaying ? 'Pause' : 'Play',
                  onPressed: service.togglePlayPause,
                ),
                IconButton(
                  icon: Icon(
                    Icons.stop,
                    color: colors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Stop',
                  onPressed: service.stop,
                ),
                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: colors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Next Ayah',
                  onPressed: service.playNext,
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_outline,
                    color: colors.active,
                    size: 24.r,
                  ),
                  tooltip: 'Change Qari',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ReciterSelectionDialog(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
