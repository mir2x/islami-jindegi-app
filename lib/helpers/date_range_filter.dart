/// Resolves the date filter's query params into the concrete bounds that both
/// the .NET API and the offline SQLite database understand.
///
/// The filter stores either a preset (`dateRange: 'now-1m'`) or an explicit
/// range (`dateFrom`/`dateTo`). Presets are resolved here rather than on the
/// server so the online and offline code paths filter identically, and so the
/// API only ever has to understand two plain date bounds.
class DateRangeFilter {
  const DateRangeFilter({this.from, this.to});

  /// Inclusive bounds as `yyyy-MM-dd`, or null when that end is unbounded.
  final String? from;
  final String? to;

  bool get isEmpty => from == null && to == null;

  factory DateRangeFilter.of(Map qParams) {
    final preset = _nonEmpty(qParams['dateRange']);
    if (preset != null) {
      final start = _presetStart(preset);
      if (start != null) return DateRangeFilter(from: formatDay(start));
    }

    return DateRangeFilter(
      from: _nonEmpty(qParams['dateFrom']),
      to: _nonEmpty(qParams['dateTo']),
    );
  }

  /// `DateFormat` would render Bangla digits under a `bn` locale, which neither
  /// the API nor a SQLite string comparison can read. Build the ISO day by hand.
  static String formatDay(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static DateTime? parseDay(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static String? _nonEmpty(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return value;
  }

  static DateTime? _presetStart(String preset) {
    final now = DateTime.now();
    return switch (preset) {
      'now-1w' => now.subtract(const Duration(days: 7)),
      'now-1m' => DateTime(now.year, now.month - 1, now.day),
      'now-1y' => DateTime(now.year - 1, now.month, now.day),
      'now-5y' => DateTime(now.year - 5, now.month, now.day),
      'now-10y' => DateTime(now.year - 10, now.month, now.day),
      _ => null,
    };
  }
}
