import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../models/sura_list_item.dart';

const Map<int, int> _ayahCounts = {
  1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129,
  10: 109, 11: 123, 12: 111, 13: 43, 14: 52, 15: 99, 16: 128, 17: 111,
  18: 110, 19: 98, 20: 135, 21: 112, 22: 78, 23: 118, 24: 64, 25: 77,
  26: 227, 27: 93, 28: 88, 29: 69, 30: 60, 31: 34, 32: 30, 33: 73, 34: 54,
  35: 45, 36: 83, 37: 182, 38: 88, 39: 75, 40: 85, 41: 54, 42: 53, 43: 89,
  44: 59, 45: 37, 46: 35, 47: 38, 48: 29, 49: 18, 50: 45, 51: 60, 52: 49,
  53: 62, 54: 55, 55: 78, 56: 96, 57: 29, 58: 22, 59: 24, 60: 13, 61: 14,
  62: 11, 63: 11, 64: 18, 65: 12, 66: 12, 67: 30, 68: 52, 69: 52, 70: 44,
  71: 28, 72: 28, 73: 20, 74: 56, 75: 40, 76: 31, 77: 50, 78: 40, 79: 46,
  80: 42, 81: 29, 82: 19, 83: 36, 84: 25, 85: 22, 86: 17, 87: 19, 88: 26,
  89: 30, 90: 20, 91: 15, 92: 21, 93: 11, 94: 8, 95: 8, 96: 19, 97: 5,
  98: 8, 99: 8, 100: 11, 101: 11, 102: 8, 103: 3, 104: 9, 105: 5, 106: 4,
  107: 7, 108: 3, 109: 6, 110: 3, 111: 5, 112: 4, 113: 5, 114: 6,
};

class SuraListItem extends ConsumerStatefulWidget {
  final SuraListItemModel sura;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const SuraListItem({
    super.key,
    required this.sura,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  ConsumerState<SuraListItem> createState() => _SuraListItemState();
}

class _SuraListItemState extends ConsumerState<SuraListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Create a blink animation (2 blinks = forward, reverse, forward, reverse)
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant SuraListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final highlightColor = isClassic ? colors.appBarBg : colors.active;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isActive = widget.isHighlighted;
        return Container(
          decoration: BoxDecoration(
            color: isActive
                ? highlightColor.withValues(
                    alpha: 0.28 + _animation.value * 0.20,
                  )
                : null,
            border: isActive
                ? Border(
                    left: BorderSide(
                      color: highlightColor.withValues(
                        alpha: 0.85 + _animation.value * 0.15,
                      ),
                      width: 4.0,
                    ),
                  )
                : null,
            borderRadius: isActive
                ? const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
                : null,
          ),
          child: child,
        );
      },
      child: InkWell(
        onTap: () {
          widget.onTap?.call();
          Future.delayed(Duration.zero, () {
            if (!context.mounted) return;
            context.push(
              buildSuraRoute(suraNumber: widget.sura.number),
            );
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              _buildSuraNumber(),
              const SizedBox(width: 16.0),
              Expanded(child: _buildSuraNames()),
              const SizedBox(width: 8.0),
              _buildRevelationInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuraNumber() {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isClassic ? colors.appBarBg : colors.active;
    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.highlight.withValues(
          alpha: isClassic ? 0.62 : (isDark ? 0.8 : 1.0),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.sura.number.toBengaliDigit(),
        style: TextStyle(
          wordSpacing: 3,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: accentColor,
        ),
      ),
    );
  }

  Widget _buildSuraNames() {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final count = _ayahCounts[widget.sura.number] ?? 0;
    final countStr = isBn ? count.toBengaliDigit() : count.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.sura.nameBangla,
                style: TextStyle(
                  wordSpacing: 3,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? null : colors.primaryText,
                ),
              ),
              TextSpan(
                text: ' ($countStr)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.sura.meaningBangla,
          style: TextStyle(
            wordSpacing: 3,
            fontSize: 13,
            color: colors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildRevelationInfo() {
    List<List<dynamic>> iconData =
        widget.sura.revelationType == RevelationType.Makki
            ? HugeIcons.strokeRoundedKaaba01
            : HugeIcons.strokeRoundedMosque04;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(
          icon: iconData,
          color: Theme.of(context).extension<AppThemeColors>()!.secondaryText,
          size: 28,
        ),
        const SizedBox(width: 8.0),
        Text(
          widget.sura.nameArabic,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.amiri(
            fontSize: 18,
            color: Theme.of(context).extension<AppThemeColors>()!.arabicText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
