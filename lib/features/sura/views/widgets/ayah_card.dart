import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/sura/models/ayah.dart';
import 'package:native_app/features/sura/views/widgets/ayah_action_bottom_sheet.dart';
import 'package:native_app/features/sura/providers/font_settings_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../../../core/utils/adaptive_text.dart';

class AyahCard extends ConsumerWidget {
  final int suraNumber;
  final Ayah ayah;
  final String suraName;
  final bool isHighlighted;

  const AyahCard({
    super.key,
    required this.suraNumber,
    required this.ayah,
    required this.suraName,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTranslators = ref.watch(selectedTranslatorsProvider);
    final showTranslations = ref.watch(showTranslationsProvider);
    final showWords = ref.watch(showWordByWordProvider);

    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final accent = colors.active;
    final accentBg = colors.highlight;
    final cardColor = isHighlighted ? accentBg : colors.cardBg;
    final borderColor = isHighlighted ? accent : colors.divider;
    final cardElevation = isHighlighted ? 4.0 : 0.0;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () =>
            showAyahActionBottomSheet(context, suraNumber, ayah, suraName, ref),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          elevation: cardElevation,
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: borderColor, width: 2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardHeader(context),
                const SizedBox(height: 16),
                if (showWords)
                  _buildWordByWordView(ayah.words, ref, context)
                else
                  _buildArabicText(ref, context),
                if (showTranslations &&
                    selectedTranslators.isNotEmpty &&
                    !showWords)
                  _buildTranslations(selectedTranslators, ref, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final accent = colors.active;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: accent,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              ayah.ayah.toBengaliDigit(),
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
                color: accent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Row(
          children: [
            _ColorDot(color: colors.active),
            _ColorDot(color: colors.secondary),
            _ColorDot(color: colors.divider),
          ],
        ),
      ],
    );
  }

  Widget _buildWordByWordView(
      List<WordByWord> words, WidgetRef ref, BuildContext context) {
    final arabicFont = ref.watch(arabicFontProvider);
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final bengaliFont = ref.watch(bengaliFontProvider);
    final bengaliFontSize = ref.watch(bengaliFontSizeProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final accent = colors.active;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: 24.0,
        spacing: 8.0,
        children: words.map((word) {
          return SizedBox(
            width: 75.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Arabic text - never wraps, scales down if too wide
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    word.arabic,
                    style: TextStyle(
                      fontFamily: arabicFont,
                      fontSize: arabicFontSize,
                      color: colors.primaryText,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                SizedBox(height: 8.0.h),
                // Bangla text - wraps to multiple lines
                Text(
                  word.bengali,
                  style: TextStyle(
                    fontFamily: bengaliFont,
                    fontSize: bengaliFontSize,
                    color: accent,
                    wordSpacing: 3,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArabicText(WidgetRef ref, BuildContext context) {
    final arabicFont = ref.watch(arabicFontProvider);
    final arabicFontSize = ref.watch(arabicFontSizeProvider);

    return Text(
      ayah.arabicText,
      style: TextStyle(
        fontFamily: arabicFont,
        fontSize: arabicFontSize,
        height: 1.8,
        color: Theme.of(context).extension<AppThemeColors>()!.primaryText,
        letterSpacing: 0,
      ),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildTranslations(
      List<String> selectedTranslators, WidgetRef ref, BuildContext context) {
    final bengaliFont = ref.watch(bengaliFontProvider);
    final bengaliFontSize = ref.watch(bengaliFontSizeProvider);

    final translationsToShow = ayah.translations
        .where((t) => selectedTranslators.contains(t.translatorName))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
            height: 30,
            thickness: 0.5,
            color: Theme.of(context).extension<AppThemeColors>()!.divider),
        ...translationsToShow.map((translation) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveText(
                  translation.translatorName,
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    color: Theme.of(context)
                        .extension<AppThemeColors>()!
                        .secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                AdaptiveText(
                  translation.text,
                  style: TextStyle(
                    fontFamily: bengaliFont,
                    fontSize: bengaliFontSize,
                    height: 1.5,
                    color: Theme.of(context)
                        .extension<AppThemeColors>()!
                        .primaryText,
                  ),
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
