import 'dart:async';
import 'package:flutter/material.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/helpers/hijri_localization.dart';

const double _kRowHeight = 42.0;
const int _kMaxRows = 6;
const double _kPickerWidth = 330.0;
const double _kPickerHeight = _kRowHeight * (_kMaxRows + 2);
const Duration _kScrollDuration = Duration(milliseconds: 200);

class GregorianMonthPicker extends StatefulWidget {
  const GregorianMonthPicker({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<GregorianMonthPicker> createState() => _GregorianMonthPickerState();
}

class _GregorianMonthPickerState extends State<GregorianMonthPicker> {
  late PageController _controller;
  late DateTime _current;
  late DateTime _today;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _current = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    final int page = _monthDelta(widget.firstDate, widget.selectedDate);
    _controller = PageController(initialPage: page);
    _scheduleNextDay();
  }

  void _scheduleNextDay() {
    final tomorrow = DateTime(_today.year, _today.month, _today.day + 1);
    final duration = tomorrow.difference(DateTime.now()) + const Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer(duration, () {
      setState(() {
        _today = DateTime.now();
        _scheduleNextDay();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  static int _monthDelta(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + end.month - start.month;
  }

  DateTime _addMonths(DateTime base, int months) {
    int totalMonths = base.year * 12 + (base.month - 1) + months;
    return DateTime(totalMonths ~/ 12, totalMonths % 12 + 1);
  }

  bool get _isFirst {
    return !_current.isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  bool get _isLast {
    return !_current.isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  void _prevMonth() {
    if (!_isFirst) {
      _controller.previousPage(duration: _kScrollDuration, curve: Curves.ease);
    }
  }

  void _nextMonth() {
    if (!_isLast) {
      _controller.nextPage(duration: _kScrollDuration, curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kPickerWidth,
      height: _kPickerHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _monthDelta(widget.firstDate, widget.lastDate) + 1,
            onPageChanged: (page) {
              setState(() {
                _current = _addMonths(widget.firstDate, page);
              });
            },
            itemBuilder: (context, index) {
              final month = _addMonths(widget.firstDate, index);
              return _MonthGrid(
                displayedMonth: month,
                selectedDate: widget.selectedDate,
                today: _today,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onChanged: widget.onChanged,
              );
            },
          ),
          PositionedDirectional(
            top: 0,
            start: 8,
            child: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _isFirst ? null : _prevMonth,
            ),
          ),
          PositionedDirectional(
            top: 0,
            end: 8,
            child: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _isLast ? null : _nextMonth,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.today,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  });

  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime today;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  // 0 = Sunday offset
  static int _firstDayOffset(int year, int month) {
    return DateTime(year, month, 1).weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int days = _daysInMonth(year, month);
    final int offset = _firstDayOffset(year, month);

    // Month/year header label
    final String headerLabel = _buildHeader(lang, year, month);

    // Weekday labels
    final List<String> weekdays = lang == 'bn'
        ? weekdaysBengaliShort
        : _englishShortWeekdays;

    final List<Widget> cells = [];

    // Weekday header row
    for (final wd in weekdays) {
      cells.add(Center(
        child: Text(
          wd,
          style: theme.textTheme.bodySmall,
        ),
      ));
    }

    // Empty cells before first day
    for (int i = 0; i < offset; i++) {
      cells.add(const SizedBox.shrink());
    }

    // Day cells
    for (int d = 1; d <= days; d++) {
      final date = DateTime(year, month, d);
      final bool isSelected = selectedDate.year == year &&
          selectedDate.month == month &&
          selectedDate.day == d;
      final bool isToday =
          today.year == year && today.month == month && today.day == d;
      final bool disabled =
          date.isBefore(DateTime(firstDate.year, firstDate.month, firstDate.day)) ||
          date.isAfter(DateTime(lastDate.year, lastDate.month, lastDate.day));

      TextStyle? style = theme.textTheme.bodyMedium;
      BoxDecoration? decoration;

      if (isSelected) {
        style = theme.textTheme.bodyLarge
            ?.copyWith(color: colorScheme.onSecondary);
        decoration = BoxDecoration(
          color: colorScheme.secondary,
          shape: BoxShape.circle,
        );
      } else if (disabled) {
        style = theme.textTheme.bodyMedium
            ?.copyWith(color: theme.disabledColor);
      } else if (isToday) {
        style = theme.textTheme.bodyLarge
            ?.copyWith(color: colorScheme.secondary);
      }

      final String label = lang == 'bn'
          ? d.toBengaliDigit()
          : d.toString();

      Widget cell = Container(
        decoration: decoration,
        child: Center(child: Text(label, style: style)),
      );

      if (!disabled) {
        cell = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(date),
          child: cell,
        );
      }

      cells.add(cell);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: _kRowHeight,
            child: Center(
              child: Text(headerLabel, style: theme.textTheme.titleMedium),
            ),
          ),
          Flexible(
            child: GridView.custom(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              childrenDelegate: SliverChildListDelegate(
                cells,
                addRepaintBoundaries: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildHeader(String lang, int year, int month) {
    const List<String> engMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const List<String> bnMonths = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
    ];

    if (lang == 'bn') {
      return '${bnMonths[month - 1]} ${year.toBengaliDigit()}';
    }
    return '${engMonths[month - 1]} $year';
  }
}

const List<String> _englishShortWeekdays = [
  'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
];
