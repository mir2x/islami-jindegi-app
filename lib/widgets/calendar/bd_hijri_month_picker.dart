import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/hijri_localization.dart';

const double _kHijriRowHeight = 42.0;
const int _kHijriMaxRows = 6;
const double _kHijriPickerWidth = 330.0;
const double _kHijriPickerHeight = _kHijriRowHeight * (_kHijriMaxRows + 2);
const Duration _kHijriScrollDuration = Duration(milliseconds: 200);
const Duration _kHijriMinimumLoading = Duration(milliseconds: 600);
const Duration _kHijriRetryDelay = Duration(milliseconds: 350);

class BdHijriMonthPicker extends StatefulWidget {
  const BdHijriMonthPicker({
    super.key,
    required this.settings,
    required this.selectedDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
  });

  final Map settings;
  final HijriCalendar selectedDate;
  final ValueChanged<HijriCalendar> onChanged;
  final HijriCalendar firstDate;
  final HijriCalendar lastDate;

  @override
  State<BdHijriMonthPicker> createState() => _BdHijriMonthPickerState();
}

class _BdHijriMonthPickerState extends State<BdHijriMonthPicker> {
  late PageController _controller;
  late _HijriMonth _current;
  late HijriCalendar _today;
  Timer? _timer;
  final Map<String, _BdHijriMonthData> _monthCache = {};
  final Map<String, Future<_BdHijriMonthData?>> _monthRequests = {};

  @override
  void initState() {
    super.initState();
    _today = adjustedHijriDate(widget.settings);
    _current = _HijriMonth(
      widget.selectedDate.hYear,
      widget.selectedDate.hMonth,
    );
    final page = _monthDelta(
      _HijriMonth(widget.firstDate.hYear, widget.firstDate.hMonth),
      _current,
    );
    _controller = PageController(initialPage: page);
    _scheduleNextDay();
  }

  void _scheduleNextDay() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final duration = tomorrow.difference(now) + const Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer(duration, () {
      if (!mounted) return;
      setState(() {
        _today = adjustedHijriDate(widget.settings);
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

  static int _monthDelta(_HijriMonth start, _HijriMonth end) {
    return (end.year - start.year) * 12 + end.month - start.month;
  }

  _HijriMonth _addMonths(_HijriMonth base, int months) {
    final totalMonths = base.year * 12 + (base.month - 1) + months;
    return _HijriMonth(totalMonths ~/ 12, totalMonths % 12 + 1);
  }

  bool get _isFirst {
    final first = _HijriMonth(widget.firstDate.hYear, widget.firstDate.hMonth);
    return _monthDelta(first, _current) <= 0;
  }

  bool get _isLast {
    final last = _HijriMonth(widget.lastDate.hYear, widget.lastDate.hMonth);
    return _monthDelta(_current, last) <= 0;
  }

  void _prevMonth() {
    if (_isFirst) return;
    _controller.previousPage(
      duration: _kHijriScrollDuration,
      curve: Curves.ease,
    );
  }

  void _nextMonth() {
    if (_isLast) return;
    _controller.nextPage(
      duration: _kHijriScrollDuration,
      curve: Curves.ease,
    );
  }

  Future<_BdHijriMonthData?> _fetchMonth(_HijriMonth month) async {
    final prefs = widget.settings['preferences'];
    final String? backendUrl =
        widget.settings['backendUrl'] as String? ??
        prefs?.getString('hijriBackendUrl') ??
        dotenv.env['HIJRI_BACKEND_URL'];
    final String countryCode =
        widget.settings['countryCode'] as String? ??
        prefs?.getString('countryCode') ??
        'BD';
    if (backendUrl == null || backendUrl.isEmpty) return null;

    try {
      final dio = Dio(BaseOptions(
        baseUrl: '$backendUrl/api',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),);
      final response = await dio.get(
        '/hijri_month',
        queryParameters: {
          'country-code': countryCode,
          'hijri-year': month.year,
          'hijri-month': month.month,
        },
      );
      final data = response.data['data'];
      if (data == null) return null;
      return _BdHijriMonthData(
        monthLength: (data['month_length'] as num).toInt(),
        gregorianStartDate: DateTime.parse(data['gregorian_start_date'] as String),
      );
    } catch (_) {
      return null;
    }
  }

  Future<_BdHijriMonthData?> _loadMonth(_HijriMonth month) {
    final key = '${month.year}-${month.month}';
    final cached = _monthCache[key];
    if (cached != null) {
      return Future.value(cached);
    }

    final inFlight = _monthRequests[key];
    if (inFlight != null) {
      return inFlight;
    }

    final request = () async {
      final stopwatch = Stopwatch()..start();
      var monthData = await _fetchMonth(month);
      if (monthData == null) {
        await Future.delayed(_kHijriRetryDelay);
        monthData = await _fetchMonth(month);
      }

      final remaining = _kHijriMinimumLoading - stopwatch.elapsed;
      if (!remaining.isNegative) {
        await Future.delayed(remaining);
      }

      if (monthData != null) {
        _monthCache[key] = monthData;
      }
      return monthData;
    }();

    _monthRequests[key] = request.whenComplete(() {
      _monthRequests.remove(key);
    });
    return _monthRequests[key]!;
  }

  void _retryMonth(_HijriMonth month) {
    final key = '${month.year}-${month.month}';
    _monthCache.remove(key);
    _monthRequests.remove(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kHijriPickerWidth,
      height: _kHijriPickerHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _monthDelta(
                  _HijriMonth(widget.firstDate.hYear, widget.firstDate.hMonth),
                  _HijriMonth(widget.lastDate.hYear, widget.lastDate.hMonth),
                ) +
                1,
            onPageChanged: (page) {
              setState(() {
                _current = _addMonths(
                  _HijriMonth(widget.firstDate.hYear, widget.firstDate.hMonth),
                  page,
                );
              });
            },
            itemBuilder: (context, index) {
              final displayedMonth = _addMonths(
                _HijriMonth(widget.firstDate.hYear, widget.firstDate.hMonth),
                index,
              );
              return _BdHijriMonthGrid(
                displayedMonth: displayedMonth,
                selectedDate: widget.selectedDate,
                today: _today,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onChanged: widget.onChanged,
                monthDataFuture: _loadMonth(displayedMonth),
                onRetry: () => _retryMonth(displayedMonth),
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

class _BdHijriMonthGrid extends StatelessWidget {
  const _BdHijriMonthGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.today,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.monthDataFuture,
    required this.onRetry,
  });

  final _HijriMonth displayedMonth;
  final HijriCalendar selectedDate;
  final HijriCalendar today;
  final HijriCalendar firstDate;
  final HijriCalendar lastDate;
  final ValueChanged<HijriCalendar> onChanged;
  final Future<_BdHijriMonthData?> monthDataFuture;
  final VoidCallback onRetry;

  bool _isDisabled(HijriCalendar date) {
    if (date.hYear < firstDate.hYear ||
        (date.hYear == firstDate.hYear && date.hMonth < firstDate.hMonth)) {
      return true;
    }
    if (date.hYear == firstDate.hYear &&
        date.hMonth == firstDate.hMonth &&
        date.hDay < firstDate.hDay) {
      return true;
    }
    if (date.hYear > lastDate.hYear ||
        (date.hYear == lastDate.hYear && date.hMonth > lastDate.hMonth)) {
      return true;
    }
    if (date.hYear == lastDate.hYear &&
        date.hMonth == lastDate.hMonth &&
        date.hDay > lastDate.hDay) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final headerLabel = lang == 'bn'
        ? hijriMonthYearBengali(displayedMonth.month, displayedMonth.year)
        : hijriMonthYearEnglish(displayedMonth.month, displayedMonth.year);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: _kHijriRowHeight,
            child: Center(
              child: Text(headerLabel, style: theme.textTheme.titleMedium),
            ),
          ),
          Expanded(
            child: FutureBuilder<_BdHijriMonthData?>(
              future: monthDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                }
                final monthData = snapshot.data;
                if (monthData == null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang == 'bn'
                              ? 'ক্যালেন্ডারের ডাটা লোড করা যায়নি'
                              : 'Could not load calendar data',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: onRetry,
                          child: Text(
                            lang == 'bn' ? 'আবার চেষ্টা করুন' : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final colorScheme = theme.colorScheme;
                final days = monthData.monthLength;
                final offset = monthData.gregorianStartDate.weekday % 7;
                final weekdays = lang == 'bn'
                    ? weekdaysBengaliShort
                    : _englishShortWeekdays;
                final cells = <Widget>[];

                for (final wd in weekdays) {
                  cells.add(Center(child: Text(wd, style: theme.textTheme.bodySmall)));
                }

                for (int i = 0; i < offset; i++) {
                  cells.add(const SizedBox.shrink());
                }

                for (int d = 1; d <= days; d++) {
                  final date = HijriCalendar()
                    ..hYear = displayedMonth.year
                    ..hMonth = displayedMonth.month
                    ..hDay = d;
                  final isSelected = selectedDate.hYear == date.hYear &&
                      selectedDate.hMonth == date.hMonth &&
                      selectedDate.hDay == date.hDay;
                  final isToday = today.hYear == date.hYear &&
                      today.hMonth == date.hMonth &&
                      today.hDay == date.hDay;
                  final disabled = _isDisabled(date);

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

                  final label = lang == 'bn' ? d.toBengaliDigit() : d.toString();

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

                return GridView.custom(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  childrenDelegate: SliverChildListDelegate(
                    cells,
                    addRepaintBoundaries: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HijriMonth {
  const _HijriMonth(this.year, this.month);

  final int year;
  final int month;
}

class _BdHijriMonthData {
  const _BdHijriMonthData({
    required this.monthLength,
    required this.gregorianStartDate,
  });

  final int monthLength;
  final DateTime gregorianStartDate;
}

const List<String> _englishShortWeekdays = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];
