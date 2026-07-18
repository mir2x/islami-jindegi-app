import 'package:flutter/material.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

class TimeInput extends ConsumerStatefulWidget {
  const TimeInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.title,
  });

  final String initialValue;
  final void Function(String?) onChanged;
  final String? title;

  @override
  ConsumerState<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends ConsumerState<TimeInput> {
  static const int _minMinutes = -60;
  static const int _maxMinutes = 60;

  late int _value;

  @override
  void initState() {
    super.initState();
    _value = int.tryParse(widget.initialValue) ?? 0;
  }

  @override
  void didUpdateWidget(covariant TimeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = int.tryParse(widget.initialValue) ?? 0;
    }
  }

  void _updateValue(int nextValue) {
    if (nextValue < _minMinutes || nextValue > _maxMinutes) return;
    setState(() {
      _value = nextValue;
    });
    widget.onChanged(_value.toString());
  }

  String _toLocalizedDigits(String text, String currentLang) {
    if (currentLang != 'bn') return text;
    const bengaliDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return text.split('').map((char) {
      final digit = int.tryParse(char);
      return digit == null ? char : bengaliDigits[digit];
    }).join();
  }

  String _displayValue(String currentLang) {
    final prefix = _value > 0 ? '+' : '';
    final text = '$prefix$_value';
    return _toLocalizedDigits(text, currentLang);
  }

  String _displayBound(int value, String currentLang) {
    final text = value.toString();
    return _toLocalizedDigits(text, currentLang);
  }

  String _rangeLabel(String currentLang) {
    if (currentLang == 'bn') {
      return 'সর্বনিম্ন: ${_displayBound(_minMinutes, currentLang)}, সর্বোচ্চ: ${_displayBound(_maxMinutes, currentLang)}';
    }
    return 'Min: ${_displayBound(_minMinutes, currentLang)}, Max: ${_displayBound(_maxMinutes, currentLang)}';
  }

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final title = widget.title ?? locales.minutes;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClassic = appTheme.primary == AppThemeColors.classic.primary &&
        appTheme.appBarBg == AppThemeColors.classic.appBarBg;

    final cardColor = Color.alphaBlend(
      appTheme.surfaceBg.withValues(alpha: 0.74),
      appTheme.cardBg,
    );
    final innerColor = isDark
        ? appTheme.surfaceBg.withValues(alpha: 0.96)
        : isClassic
            ? const Color(0xFFF7FBFA)
            : const Color(0xFFFDFBF7);
    final titleColor = isDark
        ? appTheme.primaryText
        : isClassic
            ? appTheme.appBarBg
            : appTheme.primary;
    final rangeColor = isDark
        ? appTheme.secondaryText.withValues(alpha: 0.9)
        : isClassic
            ? appTheme.secondaryText
            : appTheme.primaryText.withValues(alpha: 0.58);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: appTheme.divider.withValues(alpha: 0.38),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _rangeLabel(currentLang),
                style: textTheme.labelSmall?.copyWith(
                  color: rangeColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: innerColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: appTheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _StepperButton(
                  icon: Icons.remove_rounded,
                  filled: false,
                  isClassic: isClassic,
                  onTap: _value <= _minMinutes
                      ? null
                      : () => _updateValue(_value - 1),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _displayValue(currentLang),
                      style: textTheme.headlineSmall?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add_rounded,
                  filled: true,
                  isClassic: isClassic,
                  onTap: _value >= _maxMinutes
                      ? null
                      : () => _updateValue(_value + 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.filled,
    required this.isClassic,
    required this.onTap,
  });

  final IconData icon;
  final bool filled;
  final bool isClassic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final disabled = onTap == null;

    final backgroundColor = disabled
        ? appTheme.highlight.withValues(alpha: 0.28)
        : filled
            ? isClassic
                ? appTheme.secondary
                : appTheme.primary
            : appTheme.highlight.withValues(alpha: 0.55);
    final foregroundBrightness =
        ThemeData.estimateBrightnessForColor(backgroundColor);
    final iconColor = disabled
        ? appTheme.secondaryText.withValues(alpha: 0.5)
        : filled
            ? (foregroundBrightness == Brightness.dark
                ? const Color(0xFFF8F4EA)
                : appTheme.primaryText)
            : isClassic
                ? appTheme.appBarBg
                : appTheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}
