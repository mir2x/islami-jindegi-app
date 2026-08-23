import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Next extends StatefulWidget {
  const Next({
    super.key,
    required this.onNext,
    this.nextDisabled = false,
    this.resolveDisabled,
    this.resolveDisabledKey,
    this.contrastColor = true,
    this.iconColor,
  });

  final Future? Function() onNext;
  final bool nextDisabled;
  final Future<bool> Function()? resolveDisabled;
  final Object? resolveDisabledKey;
  final bool contrastColor;
  final Color? iconColor;

  @override
  State<Next> createState() => _NextState();
}

class _NextState extends State<Next> {
  bool _inFlight = false;
  bool? _resolvedDisabled;

  @override
  void initState() {
    super.initState();
    _resolveDisabled();
  }

  @override
  void didUpdateWidget(covariant Next oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resolveDisabledKey != widget.resolveDisabledKey ||
        oldWidget.nextDisabled != widget.nextDisabled) {
      _resolvedDisabled = null;
      _resolveDisabled();
    }
  }

  Future<void> _resolveDisabled() async {
    final resolver = widget.resolveDisabled;
    if (resolver == null || widget.nextDisabled) return;
    final disabled = await resolver();
    if (mounted) setState(() => _resolvedDisabled = disabled);
  }

  Future<void> _run() async {
    if (_inFlight || widget.nextDisabled || _resolvedDisabled == true) return;
    setState(() => _inFlight = true);
    try {
      await widget.onNext();
    } finally {
      if (mounted) setState(() => _inFlight = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final controlColor = isClassic ? colors.appBarBg : colors.primary;

    final disabled =
        widget.nextDisabled || _inFlight || _resolvedDisabled == true;
    Color? iconColor = disabled
        ? colors.secondaryText
        : widget.contrastColor
            ? controlColor
            : null;
    iconColor = widget.iconColor ?? iconColor;

    return IconButton(
      icon: const Icon(Icons.skip_next_rounded),
      color: iconColor,
      padding: const EdgeInsets.only(
        top: 10,
        right: 10,
        bottom: 10,
        left: 5,
      ),
      constraints: const BoxConstraints(),
      onPressed: disabled ? null : _run,
    );
  }
}
