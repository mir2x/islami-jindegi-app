import 'package:adhan/adhan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/core/services/timezone_resolver.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Los Angeles city centre, as the manual city picker supplies it.
const losAngeles = (latitude: 34.05223, longitude: -118.24368);
const dhaka = (latitude: 23.8103, longitude: 90.4125);

/// The app's shipped calculation defaults.
const _defaultPrefs = <String, Object>{
  'method': 'Karachi',
  'madhab': 'hanafi',
  'fajr': 5,
  'sunrise': 0,
  'dhuhr': 0,
  'asr': 0,
  'maghrib': 3,
  'isha': 0,
};

PrayerTime _prayerTime({
  required ({double latitude, double longitude}) at,
  required String timezone,
  required SharedPreferences preferences,
  required DateTime on,
}) {
  return PrayerTime(
    coordinates: Coordinates(at.latitude, at.longitude),
    timezone: timezone,
    preferences: preferences,
    currentDate: on,
  );
}

String _hhmm(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues(Map.of(_defaultPrefs));
    preferences = await SharedPreferences.getInstance();
  });

  group('prayer times follow the location, not the device', () {
    test('Los Angeles is computed on the Los Angeles clock', () {
      final date = DateTime.utc(2026, 9, 1);
      final times = _prayerTime(
        at: losAngeles,
        timezone: 'America/Los_Angeles',
        preferences: preferences,
        on: date,
      );

      // Solar noon in Los Angeles on 2026-09-01 is 19:53 UTC — 12:53 PDT. The
      // dhuhr window opens a few minutes after it.
      expect(_hhmm(times.getPrayerStartDateTime('fajr', date: date)!), '05:05');
      expect(_hhmm(times.getPrayerStartDateTime('sunrise', date: date)!), '06:27');
      expect(_hhmm(times.getPrayerStartDateTime('dhuhr', date: date)!), '12:59');
      expect(_hhmm(times.getPrayerStartDateTime('asr', date: date)!), '17:28');
      expect(_hhmm(times.getPrayerStartDateTime('maghrib', date: date)!), '19:22');
    });

    test('the country-code zone this replaced was two hours out', () {
      // America/Adak is the first zone listed for "US" in the country database
      // the app used to read, so every American user got these times.
      final date = DateTime.utc(2026, 9, 1);
      final adak = _prayerTime(
        at: losAngeles,
        timezone: 'America/Adak',
        preferences: preferences,
        on: date,
      );

      // These are, to the minute, the times a user in Los Angeles was shown.
      expect(_hhmm(adak.getPrayerStartDateTime('fajr', date: date)!), '03:05');
      expect(_hhmm(adak.getPrayerStartDateTime('sunrise', date: date)!), '04:27');
      expect(_hhmm(adak.getPrayerStartDateTime('dhuhr', date: date)!), '10:59');
      expect(_hhmm(adak.getPrayerStartDateTime('asr', date: date)!), '15:28');
      expect(_hhmm(adak.getPrayerStartDateTime('maghrib', date: date)!), '17:22');
    });

    test('a prayer time is a real instant, not a wall clock stamped as UTC', () {
      // Alarms and countdowns compare against DateTime.now(), so the epoch has
      // to be the true moment. The previous representation added the zone
      // offset into a UTC value, which read correctly but pointed at an instant
      // one offset away — six hours off in Dhaka, seven in Los Angeles.
      final date = DateTime.utc(2026, 9, 1);
      final maghrib = _prayerTime(
        at: losAngeles,
        timezone: 'America/Los_Angeles',
        preferences: preferences,
        on: date,
      ).getPrayerStartDateTime('maghrib', date: date)!;

      // 19:22 PDT is 02:22 UTC the following day.
      expect(maghrib.toUtc(), DateTime.utc(2026, 9, 2, 2, 22));
    });
  });

  group('daylight saving transitions', () {
    test('prayers after a changeover use the offset in force at that moment', () {
      // US clocks go back at 02:00 local on 2026-11-01. Sampling the offset once
      // at midnight — as applying a single utcOffset to the whole day does —
      // leaves every prayer after 02:00 an hour late.
      final date = DateTime.utc(2026, 11, 1);
      final times = _prayerTime(
        at: losAngeles,
        timezone: 'America/Los_Angeles',
        preferences: preferences,
        on: date,
      );

      final dhuhr = times.getPrayerStartDateTime('dhuhr', date: date)!;
      expect(
        dhuhr.timeZoneOffset,
        const Duration(hours: -8),
        reason: 'dhuhr falls after the changeover, so it is PST',
      );
      expect(dhuhr.hour, 11, reason: 'PDT would have put it at 12');
    });
  });

  group('the zone is resolved from the coordinate', () {
    test('offline lookup places a coordinate without any network', () async {
      // No `hijriBackendUrl` in preferences, so the backend is skipped entirely
      // and this exercises the on-device polygon fallback the background
      // isolates depend on.
      expect(
        await resolveTimezone(
          latitude: losAngeles.latitude,
          longitude: losAngeles.longitude,
        ),
        'America/Los_Angeles',
      );
      expect(
        await resolveTimezone(
          latitude: dhaka.latitude,
          longitude: dhaka.longitude,
        ),
        'Asia/Dhaka',
      );
    });

    test('a zone stored by the old strategy is re-resolved, not trusted',
        () async {
      SharedPreferences.setMockInitialValues({
        ..._defaultPrefs,
        // What an install upgrading from the country-code strategy carries.
        'timezone': 'America/Adak',
        'countryCode': 'US',
      });

      expect(
        await resolveTimezone(
          latitude: losAngeles.latitude,
          longitude: losAngeles.longitude,
        ),
        'America/Los_Angeles',
      );
    });

    test('moving across a zone border invalidates the cached answer', () async {
      // Both sides of the Arizona/California border. Arizona does not observe
      // DST, so getting this wrong is a full hour in summer.
      const phoenix = (latitude: 33.44838, longitude: -112.07404);

      expect(
        await resolveTimezone(
          latitude: phoenix.latitude,
          longitude: phoenix.longitude,
        ),
        'America/Phoenix',
      );
      expect(
        await resolveTimezone(
          latitude: losAngeles.latitude,
          longitude: losAngeles.longitude,
        ),
        'America/Los_Angeles',
      );
    });

    test('an unresolvable stored zone is reported as unknown, not returned',
        () async {
      SharedPreferences.setMockInitialValues({
        ..._defaultPrefs,
        'timezone': 'Mars/Olympus_Mons',
        'timezoneSchemaVersion': timezoneSchemaVersion,
      });

      expect(await storedTimezone(), '');
    });
  });
}
