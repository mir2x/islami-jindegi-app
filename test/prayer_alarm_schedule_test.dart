import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/core/services/prayer_alarm_plan.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dhaka, so the plan does not depend on the machine running the test.
const _base = <String, Object>{
  'method': 'Karachi',
  'madhab': 'hanafi',
  'fajr': 5,
  'sunrise': 0,
  'dhuhr': 0,
  'asr': 0,
  'maghrib': 3,
  'isha': 0,
  'latitude': '23.8103',
  'longitude': '90.4125',
  'locale': 'en',
};

Map<String, Object> _prefs(Map<String, Object> extra) => {..._base, ...extra};

Map<String, Object> _enabled(String prayerKey, {Map<String, Object>? extra}) =>
    _prefs({'alarm_${prayerKey}_enabled': true, ...?extra});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('the horizon', () {
    test('arms several days per prayer, not just the next occurrence',
        () async {
      SharedPreferences.setMockInitialValues(_enabled('fajr'));

      final planned = await PrayerAlarmService.planAlarms();

      // The old scheduler produced exactly one. Anything less than a handful
      // leaves the chain depending on background execution to survive.
      expect(planned.length, greaterThan(1));
      expect(planned.every((a) => a.prayerKey == 'fajr'), isTrue);
    });

    test('every planned alarm is in the future and strictly ordered', () async {
      SharedPreferences.setMockInitialValues(
        _prefs({
          'alarm_fajr_enabled': true,
          'alarm_maghrib_enabled': true,
        }),
      );

      final planned = await PrayerAlarmService.planAlarms();
      final now = DateTime.now();

      expect(planned, isNotEmpty);
      for (final alarm in planned) {
        expect(
          alarm.dateTime.isAfter(now),
          isTrue,
          reason: '${alarm.prayerKey} at ${alarm.dateTime} is not ahead',
        );
      }
      for (var i = 1; i < planned.length; i++) {
        expect(
          planned[i].dateTime.isBefore(planned[i - 1].dateTime),
          isFalse,
          reason: 'plan must be ordered earliest first',
        );
      }
    });

    test('ids are unique across the whole plan', () async {
      SharedPreferences.setMockInitialValues(
        _prefs({
          for (final key in PrayerAlarmService.prayerKeys)
            'alarm_${key}_enabled': true,
        }),
      );

      final planned = await PrayerAlarmService.planAlarms();
      final ids = planned.map((a) => a.id).toSet();

      expect(ids.length, planned.length);
    });

    test('an id is stable for the same occurrence across re-plans', () async {
      SharedPreferences.setMockInitialValues(_enabled('fajr'));

      final first = await PrayerAlarmService.planAlarms();
      final second = await PrayerAlarmService.planAlarms();

      // Stability is what lets the scheduler diff instead of tearing the whole
      // set down and rebuilding it — which is what silenced a ringing azan.
      expect(
        {for (final a in second) a.id: a.dateTime},
        {for (final a in first) a.id: a.dateTime},
      );
    });
  });

  group('user settings', () {
    test('a disabled prayer contributes nothing', () async {
      SharedPreferences.setMockInitialValues(_prefs({}));
      expect(await PrayerAlarmService.planAlarms(), isEmpty);
    });

    test('repeat days are honoured in the location calendar', () async {
      // Fridays only.
      SharedPreferences.setMockInitialValues(
        _enabled(
          'fajr',
          extra: {'alarm_fajr_repeat_days': <String>['5']},
        ),
      );

      final planned = await PrayerAlarmService.planAlarms();

      expect(planned, isNotEmpty);
      expect(
        planned.every((a) => a.dateTime.weekday == DateTime.friday),
        isTrue,
      );
    });

    test('a single-weekday reminder is armed whatever day it is run', () async {
      // The horizon starts today, so a seven-day window gives a once-a-week
      // reminder exactly one candidate — and none at all once today's has
      // passed. Every weekday has to yield something still ahead.
      for (var weekday = DateTime.monday;
          weekday <= DateTime.sunday;
          weekday++) {
        SharedPreferences.setMockInitialValues(
          _enabled(
            'fajr',
            extra: {'alarm_fajr_repeat_days': <String>['$weekday']},
          ),
        );

        final planned = await PrayerAlarmService.planAlarms();

        expect(
          planned,
          isNotEmpty,
          reason: 'nothing armed for weekday $weekday',
        );
        expect(planned.every((a) => a.dateTime.weekday == weekday), isTrue);
      }
    });

    test('a "before" reminder lands ahead of the prayer by its offset',
        () async {
      SharedPreferences.setMockInitialValues(_enabled('fajr'));
      final at = await PrayerAlarmService.planAlarms();

      SharedPreferences.setMockInitialValues(
        _enabled(
          'fajr',
          extra: {'alarm_fajr_mode': 'before', 'alarm_fajr_before': 15},
        ),
      );
      final before = await PrayerAlarmService.planAlarms();

      expect(before.first.dateTime.isBefore(at.first.dateTime), isTrue);
      expect(
        at.first.dateTime.difference(before.first.dateTime),
        const Duration(minutes: 15),
      );
    });

    test('before and after reminders never share an id', () async {
      SharedPreferences.setMockInitialValues(
        _enabled(
          'fajr',
          extra: {'alarm_fajr_mode': 'before', 'alarm_fajr_before': 15},
        ),
      );
      final before = await PrayerAlarmService.planAlarms();

      SharedPreferences.setMockInitialValues(
        _enabled(
          'fajr',
          extra: {'alarm_fajr_mode': 'after', 'alarm_fajr_after': 15},
        ),
      );
      final after = await PrayerAlarmService.planAlarms();

      // Distinct id ranges mean switching mode cannot collide with the alarm
      // the previous mode left armed for the same day.
      expect(
        before.map((a) => a.id).toSet().intersection(
              after.map((a) => a.id).toSet(),
            ),
        isEmpty,
      );
    });

    test('the chosen azan reaches the plan', () async {
      SharedPreferences.setMockInitialValues(
        _enabled('fajr', extra: {'alarm_fajr_sound_key': 'fajr'}),
      );

      final planned = await PrayerAlarmService.planAlarms();

      expect(planned.first.soundKey, 'fajr');
      expect(planned.first.soundPath, 'assets/sounds/azan_fajr.mp3');
    });
  });

  group('plan contents', () {
    test('each alarm carries a title and body for the notification', () async {
      SharedPreferences.setMockInitialValues(_enabled('maghrib'));

      final PlannedPrayerAlarm alarm =
          (await PrayerAlarmService.planAlarms()).first;

      expect(alarm.title, 'Maghrib');
      expect(alarm.body, isNotEmpty);
    });
  });
}
