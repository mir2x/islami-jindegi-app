import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Previous extends StatefulWidget {
  const Previous({
    super.key,
    required this.onPrevious,
    this.previousDisabled = false,
    this.resolveDisabled,
    this.resolveDisabledKey,
    this.contrastColor = true,
    this.iconColor,
  });

  final Future? Function() onPrevious;
  final bool previousDisabled;
  final Future<bool> Function()? resolveDisabled;
  final Object? resolveDisabledKey;
  final bool contrastColor;
  final Color? iconColor;

  @override
  State<Previous> createState() => _PreviousState();
}

class _PreviousState extends State<Previous> {
  bool _inFlight = false;
  bool? _resolvedDisabled;

  @override
  void initState() {
    super.initState();
    _resolveDisabled();
  }

  @override
  void didUpdateWidget(covariant Previous oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resolveDisabledKey != widget.resolveDisabledKey ||
        oldWidget.previousDisabled != widget.previousDisabled) {
      _resolvedDisabled = null;
      _resolveDisabled();
    }
  }

  Future<void> _resolveDisabled() async {
    final resolver = widget.resolveDisabled;
    if (resolver == null || widget.previousDisabled) return;
    final disabled = await resolver();
    if (mounted) setState(() => _resolvedDisabled = disabled);
  }

  Future<void> _run() async {
    if (_inFlight || widget.previousDisabled || _resolvedDisabled == true)
      return;
    setState(() => _inFlight = true);
    try {
      await widget.onPrevious();
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
        widget.previousDisabled || _inFlight || _resolvedDisabled == true;
    Color? iconColor = disabled
        ? colors.secondaryText
        : widget.contrastColor
            ? controlColor
            : null;
    iconColor = widget.iconColor ?? iconColor;

    return IconButton(
      icon: const Icon(Icons.skip_previous_rounded),
      color: iconColor,
      padding: const EdgeInsets.only(
        top: 10,
        right: 5,
        bottom: 10,
        left: 10,
      ),
      constraints: const BoxConstraints(),
      onPressed: disabled ? null : _run,
    );
  }
}
