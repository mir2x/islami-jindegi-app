import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

bool _ready = false;

/// Loads the IANA database exactly once per isolate.
///
/// Three isolates need it and only one of them runs `main()`: the app, the
/// Workmanager background task, and the home_widget callback. Anything that
/// resolves a zone must call this first — `tz.getLocation` throws on an empty
/// database, and every caller here treats a throw as "fall back to the device
/// clock", which is silently wrong for a location abroad.
///
/// `latest_all` rather than `latest`: the latter omits the backward-compatible
/// link names, so ids that are still in daily use — Asia/Kuala_Lumpur,
/// Europe/Kiev, America/Godthab — fail to resolve. Both the backend and the
/// offline polygon lookup can return those.
void ensureTimezoneDatabase() {
  if (_ready) return;
  tz_data.initializeTimeZones();
  _ready = true;
}

/// True when [zoneId] names a zone this database can actually resolve.
/// Used to reject a bad id at the point it is produced rather than letting it
/// reach the prayer-time calculation, where the failure looks like a plain
/// wrong answer.
bool isResolvableTimezone(String zoneId) {
  if (zoneId.isEmpty) return false;
  ensureTimezoneDatabase();
  try {
    tz.getLocation(zoneId);
    return true;
  } catch (_) {
    return false;
  }
}
