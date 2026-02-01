import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../../model/sura_list_item.dart';

class SuraListItem extends ConsumerStatefulWidget {
  final SuraListItemModel sura;
  final bool isHighlighted;

  const SuraListItem({
    super.key,
    required this.sura,
    this.isHighlighted = false,
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
      duration: const Duration(milliseconds: 800),
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          color: widget.isHighlighted
              ? Colors.green.withOpacity(_animation.value * 0.3)
              : Colors.transparent,
          child: child,
        );
      },
      child: InkWell(
        onTap: () {
          Future.delayed(Duration.zero, () {
            if (!context.mounted) return;
            QR.to('/qurans/sura/${widget.sura.number}');
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
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.sura.number.toBengaliDigit(),
        style: TextStyle(
          fontFamily: 'bangla/solaimanlipi',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade700,
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
            fontFamily: 'bangla/solaimanlipi',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.sura.meaningBangla,
          style: TextStyle(
            fontFamily: 'bangla/solaimanlipi',
            fontSize: 14,
            color: Colors.grey.shade600,
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
        HugeIcon(icon: iconData, color: Colors.grey.shade400, size: 28),
        const SizedBox(width: 8.0),
        Text(
          widget.sura.nameArabic,
          style: GoogleFonts.amiri(
            fontSize: 18,
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
