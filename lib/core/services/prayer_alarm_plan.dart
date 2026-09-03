/// One alarm the scheduler intends to have armed.
///
/// Planning is separated from arming so the scheduler can compare what it wants
/// against what is already armed and touch only the difference. That matters
/// because arming is destructive: `Alarm.stop` on an alarm that is currently
/// ringing silences the azan, so a scheduler that tears everything down and
/// rebuilds it cuts off the adhan every time it runs.
class PlannedPrayerAlarm {
  const PlannedPrayerAlarm({
    required this.id,
    required this.prayerKey,
    required this.dateTime,
    required this.title,
    required this.body,
    required this.soundPath,
    required this.soundKey,
  });

  /// Deterministic for a given (prayer, reminder slot, calendar day), so the
  /// same occurrence keeps the same id across re-plans.
  final int id;
  final String prayerKey;

  /// The moment the alarm should fire, at the prayer location.
  final DateTime dateTime;
  final String title;
  final String body;

  /// Flutter asset path, for the `alarm` package's looping playback.
  final String soundPath;

  /// Which azan was chosen, for platforms that reference sounds by name
  /// rather than by asset path.
  final String soundKey;
}
