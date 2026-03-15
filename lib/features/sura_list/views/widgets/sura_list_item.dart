import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../models/sura_list_item.dart';

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
    final highlightColor = colors.active;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isActive = widget.isHighlighted;
        return Container(
          decoration: BoxDecoration(
            color: isActive
                ? highlightColor.withValues(
                    alpha: 0.08 + _animation.value * 0.12,
                  )
                : null,
            border: isActive
                ? Border(
                    left: BorderSide(
                      color: highlightColor.withValues(
                        alpha: 0.6 + _animation.value * 0.4,
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
              _buildSuraNames(),
              const Spacer(),
              _buildRevelationInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuraNumber() {
    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .extension<AppThemeColors>()!
            .highlight
            .withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.sura.number.toBengaliDigit(),
        style: TextStyle(
          wordSpacing: 3,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).extension<AppThemeColors>()!.active,
        ),
      ),
    );
  }

  Widget _buildSuraNames() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.sura.nameBangla,
          style: const TextStyle(
            wordSpacing: 3,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.sura.meaningBangla,
          style: TextStyle(
            wordSpacing: 3,
            fontSize: 14,
            color: Theme.of(context).extension<AppThemeColors>()!.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildRevelationInfo() {
    IconData iconData = widget.sura.revelationType == RevelationType.Makki
        ? HugeIcons.strokeRoundedKaaba01
        : HugeIcons.strokeRoundedMosque04;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HugeIcon(
          icon: iconData,
          color: Theme.of(context).extension<AppThemeColors>()!.secondaryText,
          size: 28,
        ),
        const SizedBox(width: 8.0),
        Text(
          widget.sura.nameArabic,
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
