import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/app_theme_color.dart';

class DateFilter extends ConsumerWidget {
  const DateFilter({super.key, this.queryProvider});

  final dynamic queryProvider;

  String formatDate(String date, String locale) {
    final inputDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('dd MMMM yyyy', locale).format(inputDate);
  }

  String selectedDate(
    Map qParams,
    List<Map<String, String>> options,
    String locale,
    AppLocalizations locales,
  ) {
    if (qParams.containsKey('dateFrom')) {
      final from = formatDate(qParams['dateFrom'], locale);

      if (qParams.containsKey('dateTo')) {
        final to = formatDate(qParams['dateTo'], locale);
        return '$from - $to';
      }

      return locale == 'bn' ? '$from এর পরে' : 'After $from';
    } else if (qParams.containsKey('dateTo')) {
      final to = formatDate(qParams['dateTo'], locale);
      return locale == 'bn' ? '$to এর আগে' : 'Before $to';
    } else if (qParams.containsKey('dateRange')) {
      final option = options.firstWhereOrNull(
        (o) => o['value'] == qParams['dateRange'],
      );
      if (option != null) {
        return option['label']!;
      }
    }

    return locales.date;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallMobile = screenWidth < 340;
    final sidePadding = isSmallMobile ? 10.0 : 12.0;
    final paramsProvider = queryProvider ?? queryParamsProvider;
    final qParams = ref.watch(paramsProvider);

    final List<Map<String, String>> options = [
      {'value': '', 'label': locales.anyTime},
      {'value': 'now-1w', 'label': locales.pastWeek},
      {'value': 'now-1m', 'label': locales.pastMonth},
      {'value': 'now-1y', 'label': locales.pastYear},
      {'value': 'now-5y', 'label': locales.pastFiveYears},
      {'value': 'now-10y', 'label': locales.pastTenYears},
    ];

    final selectedLabel = selectedDate(qParams, options, currentLang, locales);

    return OutlinedButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _DateFilterSheet(
            queryProvider: paramsProvider,
            options: options,
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colors.divider),
        backgroundColor:
            selectedLabel != locales.date ? colors.highlight : colors.cardBg,
        padding: EdgeInsets.only(
          left: sidePadding,
          right: isSmallMobile ? 6 : 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size.fromHeight(45),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              selectedLabel,
              style: textTheme.labelMedium?.copyWith(
                color: colors.primaryText,
                height: 1.15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: colors.secondaryText,
          ),
        ],
      ),
    );
  }
}

class _DateFilterSheet extends ConsumerStatefulWidget {
  const _DateFilterSheet({
    required this.queryProvider,
    required this.options,
  });

  final dynamic queryProvider;
  final List<Map<String, String>> options;

  @override
  ConsumerState<_DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends ConsumerState<_DateFilterSheet> {
  String? _selectedRange;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    final qParams = ref.read(widget.queryProvider);
    _selectedRange = qParams['dateRange'] as String?;

    final from = qParams['dateFrom'] as String?;
    final to = qParams['dateTo'] as String?;
    if (from != null && from.isNotEmpty) {
      _fromDate = DateFormat('yyyy-MM-dd').parse(from);
    }
    if (to != null && to.isNotEmpty) {
      _toDate = DateFormat('yyyy-MM-dd').parse(to);
    }
  }

  Future<void> _pickDate({
    required bool isFrom,
    required AppLocalizations locales,
  }) async {
    final initialDate = isFrom
        ? (_fromDate ?? _toDate ?? DateTime.now())
        : (_toDate ?? _fromDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: isFrom ? locales.dateFrom : locales.dateTo,
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedRange = null;
      if (isFrom) {
        _fromDate = picked;
        if (_toDate != null && _toDate!.isBefore(picked)) {
          _toDate = picked;
        }
      } else {
        _toDate = picked;
        if (_fromDate != null && _fromDate!.isAfter(picked)) {
          _fromDate = picked;
        }
      }
    });
  }

  void _apply() {
    final qParamsNotifier = ref.read(widget.queryProvider.notifier);

    if (_selectedRange != null) {
      qParamsNotifier.updateParams('dateRange', _selectedRange ?? '');
      qParamsNotifier.updateParams('dateFrom', '');
      qParamsNotifier.updateParams('dateTo', '');
    } else {
      qParamsNotifier.updateParams('dateRange', '');
      qParamsNotifier.updateParams(
        'dateFrom',
        _fromDate == null ? '' : DateFormat('yyyy-MM-dd').format(_fromDate!),
      );
      qParamsNotifier.updateParams(
        'dateTo',
        _toDate == null ? '' : DateFormat('yyyy-MM-dd').format(_toDate!),
      );
    }

    Navigator.of(context).pop();
  }

  void _clear() {
    setState(() {
      _selectedRange = '';
      _fromDate = null;
      _toDate = null;
    });
  }

  String _formatted(DateTime? value, String locale) {
    if (value == null) return '';
    return DateFormat('dd MMMM yyyy', locale).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenHeight < 720;
    final useSingleColumnDates = screenWidth < 380;
    final clearLabel = currentLang == 'bn' ? 'সাফ করুন' : locales.clearFilter;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, MediaQuery.of(context).viewInsets.bottom + 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420,
              maxHeight: screenHeight * (isCompact ? 0.9 : 0.8),
            ),
            child: Material(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.divider,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locales.date,
                                style: textTheme.titleLarge?.copyWith(
                                  color: colors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentLang == 'bn'
                                    ? 'সময় বা তারিখের সীমা বেছে নিন'
                                    : 'Choose a preset or date range',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: colors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentLang == 'bn' ? 'দ্রুত বাছাই' : 'Quick Select',
                            style: textTheme.labelLarge?.copyWith(
                              color: colors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.options.map((option) {
                              final isSelected =
                                  _selectedRange == option['value'] &&
                                  option['value'] != null;
                              return _PresetChip(
                                label: option['label']!,
                                selected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedRange = option['value'];
                                    _fromDate = null;
                                    _toDate = null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            currentLang == 'bn' ? 'কাস্টম রেঞ্জ' : 'Custom Range',
                            style: textTheme.labelLarge?.copyWith(
                              color: colors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.dropdownBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colors.divider),
                            ),
                            child: useSingleColumnDates
                                ? Column(
                                    children: [
                                      _DateFieldButton(
                                        label: locales.dateFrom,
                                        value: _formatted(_fromDate, currentLang),
                                        onTap: () => _pickDate(
                                          isFrom: true,
                                          locales: locales,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _DateFieldButton(
                                        label: locales.dateTo,
                                        value: _formatted(_toDate, currentLang),
                                        onTap: () => _pickDate(
                                          isFrom: false,
                                          locales: locales,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: _DateFieldButton(
                                          label: locales.dateFrom,
                                          value: _formatted(
                                            _fromDate,
                                            currentLang,
                                          ),
                                          onTap: () => _pickDate(
                                            isFrom: true,
                                            locales: locales,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 18,
                                          color: colors.secondaryText,
                                        ),
                                      ),
                                      Expanded(
                                        child: _DateFieldButton(
                                          label: locales.dateTo,
                                          value: _formatted(
                                            _toDate,
                                            currentLang,
                                          ),
                                          onTap: () => _pickDate(
                                            isFrom: false,
                                            locales: locales,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.divider),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: clearLabel,
                          onPressed: _clear,
                          style: IconButton.styleFrom(
                            minimumSize: const Size(46, 46),
                            backgroundColor: colors.dropdownBg,
                            foregroundColor: colors.secondaryText,
                            side: BorderSide(color: colors.divider),
                          ),
                          icon: const Icon(Icons.restart_alt),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _apply,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: colors.active,
                              foregroundColor: colors.appBarText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.check),
                            label: Text(
                              currentLang == 'bn' ? 'ফিল্টার প্রয়োগ' : 'Apply Filter',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Material(
      color: selected ? colors.active : colors.dropdownBg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: selected ? colors.appBarText : colors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _DateFieldButton extends StatelessWidget {
  const _DateFieldButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.secondaryText,
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Text(
                      '--',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.secondaryText.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.highlight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
