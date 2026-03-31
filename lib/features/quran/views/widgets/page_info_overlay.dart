import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';

class PageInfoOverlay extends ConsumerWidget {
  final int pageIndex;

  const PageInfoOverlay({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageInfo = ref.watch(pageInfoProvider(pageIndex + 1));
    final suraNamesList = ref.watch(suraNamesProvider);
    final isVisible = ref.watch(pageInfoVisibilityProvider);
    final paraPageMapping = ref.watch(paraPageMappingProvider);
    final hasAyahInfo = pageInfo.suraAyahRanges.isNotEmpty;

    // Hide overlay on non-content pages (e.g. opening/cover pages)
    // where no ayah ranges exist.
    if (!hasAyahInfo) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final overlayBg = colors.cardBg.withValues(alpha: 0.96);
    final overlayText = colors.primaryText;

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
            decoration: BoxDecoration(
              color: overlayBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.divider),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (pageInfo.paraNumber != null)
                  Text(
                    'পারা ${pageInfo.paraNumber?.toBengaliDigit()}: ${(pageInfo.pageNumber - (paraPageMapping[pageInfo.paraNumber] ?? pageInfo.pageNumber) + 1).toBengaliDigit()}',
                    style: TextStyle(
                      color: overlayText,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 8.h),
                ...pageInfo.suraAyahRanges.entries.map((entry) {
                  final suraNumber = entry.key;
                  final (startAyah, endAyah) = entry.value;
                  final suraName = suraNamesList[suraNumber - 1];

                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '$suraName : ${startAyah.toBengaliDigit()} - ${endAyah.toBengaliDigit()}',
                      style: TextStyle(color: overlayText, fontSize: 16.sp),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
