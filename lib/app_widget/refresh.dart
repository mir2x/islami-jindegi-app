import 'package:flutter/foundation.dart';
import 'update_data.dart';

/// Home screen widgets are populated by [updateData] alone. Every other call
/// site writes a single field (theme, location, hijri date), so a widget that
/// has never seen a full write shows its placeholders — "--:--" for the prayer
/// schedule and "00:00" for the countdown.
///
/// On Android the only scheduled full write is the 15-minute Workmanager task,
/// which the system defers freely and never runs before its first period after
/// install. Refreshing whenever the app is in the user's hands closes that gap.
DateTime? _lastRefreshAt;
Future<void>? _inFlight;

const _minimumInterval = Duration(seconds: 30);

/// Runs a full widget data refresh, throttled so that lifecycle churn (resume,
/// pause, resume) cannot queue several Flutter-side recalculations at once.
Future<void> refreshAppWidgets({bool force = false}) {
  final running = _inFlight;
  if (running != null) return running;

  final last = _lastRefreshAt;
  if (!force &&
      last != null &&
      DateTime.now().difference(last) < _minimumInterval) {
    return Future<void>.value();
  }

  final future = _run();
  _inFlight = future;
  return future;
}

Future<void> _run() async {
  try {
    await updateData();
    _lastRefreshAt = DateTime.now();
  } catch (error, stackTrace) {
    debugPrint('App widget refresh failed: $error\n$stackTrace');
  } finally {
    _inFlight = null;
  }
}
